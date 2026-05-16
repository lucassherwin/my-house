import React from "react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface FormCardProps {
  title: string;
  description?: string;
  children: React.ReactNode;
  className?: string;
}

const FormCard: React.FC<FormCardProps> = ({ title, description, children, className }) => (
  <Card className={cn("w-full max-w-sm", className)}>
    <CardHeader>
      <CardTitle>{title}</CardTitle>
      {description && <CardDescription>{description}</CardDescription>}
    </CardHeader>
    <CardContent>{children}</CardContent>
  </Card>
);

export default FormCard;
