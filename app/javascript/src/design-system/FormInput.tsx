import React from "react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

interface FormInputProps extends React.ComponentPropsWithoutRef<typeof Input> {
  label: string;
  id: string;
  className?: string;
}

const FormInput: React.FC<FormInputProps> = ({
  label,
  id,
  className,
  ...props
}) => (
  <div className={cn("space-y-2", className)}>
    <Label htmlFor={id}>{label}</Label>
    <Input id={id} {...props} />
  </div>
);

export default FormInput;
