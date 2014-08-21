From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Date: Thu, 21 Aug 2014 09:13:30 -0500
Message-ID: <20140821141330.GA1766@mtj.dyndns.org>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WxRmPkR+kzq+UUcL4FloRQRSX6kglQHA5/UbbjzmNpw=;
        b=CmzxvVv5nMJeq3Fk0EbjnwckmANQi3cxILr8F/T+G5/pz/F2zIAalJ0ExMpDod9nQ8
         rQkBnDZUZLlI/7SWeVwyuL7MmoT/7OJPUJNu1mJG0h3g5sjCZnugecusVbzgFt4PLhgD
         UYVD+Pxrs/eHNrpv+tMbCTPF612wkfT9zLZu/ciw7K8bPCegR+YH5Mf9PrnePgeTekzO
         jze/lT84azw4LLV5OeRv5d24fL/p4890Oou7uiZUlUoQjI4UVgfQNDlYDpwTb24xtE+I
         xiB0fSwA0KuR42cWTkRbyUV/sUWAxjGUXdc+kmE2tPo0Zynt1ndp4VYunqRWEBwDGVWf
         1cuA==
Content-Disposition: inline
In-Reply-To: <1408592785-6700-1-git-send-email-andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Heaton <matt-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>

Hello,

On Wed, Aug 20, 2014 at 09:46:25PM -0600, Andrea Righi wrote:
> This patch adds the following tracepoints:
>  o trace_cgroup_create       when a new cgroup is created
>  o trace_cgroup_destroy      when a cgroup is removed
>  o trace_cgroup_task_migrate when a task/thread is moved from a cgroup to another
> 
> The purpose of these tracepoints is to identify and help cgroup "managers" to
> diagnose problems and detect when they are doing an excessive amount of work.

Using TPs for this looks like a really roundabout way of doing this
when the whole interface is based on filesystem.  Extending
kernfs_notity to support directory events seems like a better way to
do this.

Thanks.

-- 
tejun
