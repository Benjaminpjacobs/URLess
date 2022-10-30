import React from "react";
import postUrl from "./Api"
import "./Form.css";

import { useForm } from "react-hook-form";

type FormProps = {
  updateShortened: Function;
};

type FormData = {
  url?: string;
};

const URLForm: React.FC<FormProps> = (props: FormProps) => {
  const {
    register,
    handleSubmit,
    formState: { errors },
    setError,
  } = useForm();
  const onSubmit = (data: FormData) => {
    const { updateShortened } = props;
    postUrl(data.url)
      .then((response: any) => {
        updateShortened(response.data.new_url);
      })
      .catch((e: any) => {
        const message = e.response.data.error.join(", ")
        setError("url", { type: "custom", message: message });
      });
  };

  const hasValidProtocol = (entry: string) => {
    let url;
    try {
      url = new URL(entry);
    } catch (_) {
      return false;
    }
    return url.protocol === "http:" || url.protocol === "https:";
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div className="Form">
        <div className="form__group field">
          <input
            className="form__field"
            placeholder="url"
            id="url"
            {...register("url", { required: true, validate: hasValidProtocol })}
          />
          <label className="form__label" htmlFor="url">URL</label>
        </div>
      </div>
      {errors.url && (
        <div className="error_container">
          <span className="loud">
            {errors.url.message || "ENTER A VALID HTTP(S) URL"}
          </span>
        </div>
      )}
      <input type="submit" value="make it shorter" />
    </form>
  );
};

export default URLForm;
