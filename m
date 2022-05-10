From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 7/9] cgroup: Add cgroup_put() in
 !CONFIG_CGROUPS case
Date: Tue, 10 May 2022 11:25:42 -0700
Message-ID: <CA+khW7hbHEEv9JsSCRj5ko=rA2ZorimkpyCCKD=7usv+fTfMNg@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com> <20220510001807.4132027-8-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHb/t4sJWtaUrfKkQwH3/sfbd07PYe3PiYuK/lpKKSM=;
        b=XF0oB5IuvA6vJGEyZOrGfxGamHtbVLL4rlc9UC4pYza1Scg0lYG1lQjzP2+uF4mYKg
         k5SqANXoXiMKqwfOjo/kCTJ1wE2u5Oh0t5b3zwwBN12RRjqZg2eGmMtC3vO29ME5jttc
         u8/DTuiEBDHhQ3IT3Tvh+OgaSJhVvk4AxYOiHIHpE+HqpB/QvLCevvw26Hs3WYNOUuT8
         UOHVIWJy37iQItWWuiSHZ2v0tMF5ao8PrVU9FwmB+Edemgi4WxwESF85LNNfolrVn0C0
         BS5Fyo4ODK6JUclQ/DNpWR7V60B/ysAFObHrRLJmgpUAivLmKv3mmULFcV+xH5hnIiyS
         zx2g==
In-Reply-To: <20220510001807.4132027-8-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 9, 2022 at 5:18 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> There is already a cgroup_get_from_id() in the !CONFIG_CGROUPS case,
> let's have a matching cgroup_put() in !CONFIG_CGROUPS too.
>
> Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/cgroup.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 5408c74d5c44..4f1d8febb9fd 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
[...]
> +
> +static inline struct cgroup *cgroup_put(void)
> +{}

Sorry Yosry, the return type and parameter type are mixed up. I will
fix it and send you an updated version.
