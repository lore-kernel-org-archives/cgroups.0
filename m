From: Todd Kjos <tkjos@google.com>
Subject: Re: [RFC v3 7/8] binder: use __kernel_pid_t and __kernel_uid_t for userspace
Date: Thu, 10 Mar 2022 11:33:20 -0800
Message-ID: <CAHRSSEy5_h9LJB4q5_OJA7fSq=ROo68UaK+hdPz-Vj-wac1Qhg@mail.gmail.com>
References: <20220309165222.2843651-1-tjmercier@google.com> <20220309165222.2843651-8-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4n6+idQ0426w+zkqVp6H2ORC9fnCFio1PZzrW8WKfUg=;
        b=OqorwzMtB49Fqip4wdm9stFVvynD2x0VggX/za+LSk2+cpHubYR90RJjOnsqoXAZJS
         PKEVUeYOlX9QtjBhjnUyqb2PSsDR+wETukIDxJkkWJI/DMsjfuTMhgIY8mWPWQI2oyra
         o9JsTO9TomWo7QJKLuNr0wMP8y/j0gAZ8MvjywUAmGwereXi3I5q/gwobTMAtCKGo3oi
         vt/8ah4AtRtGVIPPYFZ4mhGu4YhvT3BEEVZTIY2Bk+dPnS0QYjByJLaLoXqCs3CRn8kZ
         L0EpsvYejfkgMhc+/apIKBKxCkq9x+U6bH72wsz5pbyzAid1oMjnyYZpZwTlBQCy59QM
         HvbQ==
In-Reply-To: <20220309165222.2843651-8-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laur

On Wed, Mar 9, 2022 at 8:52 AM T.J. Mercier <tjmercier@google.com> wrote:
>
> The kernel interface should use types that the kernel defines instead of
> pid_t and uid_t, whose definiton is owned by libc. This fixes the header
> so that it can be included without first including sys/types.h.
>
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  include/uapi/linux/android/binder.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/android/binder.h
> index 169fd5069a1a..aa28454dbca3 100644
> --- a/include/uapi/linux/android/binder.h
> +++ b/include/uapi/linux/android/binder.h
> @@ -289,8 +289,8 @@ struct binder_transaction_data {
>
>         /* General information about the transaction. */
>         __u32           flags;
> -       pid_t           sender_pid;
> -       uid_t           sender_euid;
> +       __kernel_pid_t  sender_pid;
> +       __kernel_uid_t  sender_euid;

Are we guaranteed that this does not affect the UAPI at all? Userspace
code using this definition will have to run with kernels using the old
definition and visa-versa.

>         binder_size_t   data_size;      /* number of bytes of data */
>         binder_size_t   offsets_size;   /* number of bytes of offsets */
>
> --
> 2.35.1.616.g0bdcbb4464-goog
>
