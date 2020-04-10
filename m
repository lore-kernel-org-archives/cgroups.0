From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] clone.2: Document CLONE_INTO_CGROUP
Date: Fri, 10 Apr 2020 22:18:05 +0200
Message-ID: <b7550fcd-ba12-e64a-3228-e6668b31a8a7@gmail.com>
References: <CAKgNAkhL0zCj11LS9vfae872YVeRsxdz20sZWuXdi+UjH21=0g@mail.gmail.com>
 <20200410104132.294639-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LirB/PVqDgbE/D2KaEucIjmXEfNOl2FdUxp75VSmgWE=;
        b=S053X/y+NH90mhlB5TvqX63DVsl/Lc1yRGm0DWqWlZImLn+KezB6cOWo6TWueeZ8IG
         4SIf90nikPeanX9PTUHmFwwDP8X9SqfBKH/o/lycd7pixNk/nQPr//+IFLLbynFNlbm9
         M39etzBJ9gWDsxJ3qNI8p+i3QNY6C0gZfEsJrgvM4ofhOZt+fvAAu0P/Nq6V7zOv05kz
         An5152US6IlZbufK6mSq9CyVe/iRwJvNVTUX0KRENF1D+Xj4YHq9G8lm5CpjLzGaJjmj
         PJX3VbPrP4P87dDLht6loOfdfEgjL4y1AjNK4gi6eZDbYWB5wtIGr6nzu/hYqYRMC66t
         XKrA==
In-Reply-To: <20200410104132.294639-1-christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi Christian,

Thank you for writing this!

On 4/10/20 12:41 PM, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  man2/clone.2 | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/man2/clone.2 b/man2/clone.2
> index 39cec4c86..8d9aa9f99 100644
> --- a/man2/clone.2
> +++ b/man2/clone.2
> @@ -197,6 +197,7 @@ struct clone_args {
>      u64 tls;          /* Location of new TLS */
>      u64 set_tid;      /* Pointer to a \fIpid_t\fP array */
>      u64 set_tid_size; /* Number of elements in \fIset_tid\fP */
> +    u64 cgroup;       /* Target cgroup file descriptor for the child process */
>  };
>  .EE
>  .in
> @@ -448,6 +449,25 @@ Specifying this flag together with
>  .B CLONE_SIGHAND
>  is nonsensical and disallowed.
>  .TP
> +.BR CLONE_INTO_CGROUP " (since Linux 5.7)"
> +.\" commit ef2c41cf38a7559bbf91af42d5b6a4429db8fc68
> +By default, the child process will belong to the same cgroup as its parent.

s/belong to/be placed in/

s/cgroup/version 2 cgroup/

> +If this flag is specified the child process will be created in a
> +different cgroup than its parent.
> +
> +When using
> +.RB clone3 ()
> +the target cgroup can be specified by setting the
> +.I cl_args.cgroup
> +member to the file descriptor of the target cgroup. The cgroup file

We need to say something about how this file descriptor is
obtained. Is it by opening a directory in the v2 cgroup hierarchy?
With what flags? O_RDONLY? or is O_PATH also possible? Yes, these
are some rhetorical questions (I read your nice commit message);
these things need to be explicit in the manual page though.

Also, your commit message mentions a nice list of use cases.
I think it would be well worth capturing those in a paragraph
in the manual page text.

> +descriptor must refer to a cgroup in a cgroup v2 hierarchy
> +(see
> +.BR cgroup (2)).

s/cgroup/cgroups/
s/2/7/

> +
> +Note that all usual cgroup v2 process migration restrictions apply. See
> +.BR cgroup (2)

s/cgroup/cgroups/
s/2/7/

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
