From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Thu, 2 Mar 2023 14:58:25 +0100
Message-ID: <ZACrgV4f39P/2sZO@dhcp22.suse.cz>
References: <20230301193403.1507484-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677765505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m18Gv9KRE3npZc7Xmq0D5vkDDAhP4Hl2wTCDi72SDpo=;
        b=djSO1i5fr7YYbKoXmmYvlQeXd9sPNkcfpe5miqD9fqpAmEyoxgNZBMog929bzxFS9DRAC3
        iKApzkwryC1JfrA1lV3aNa4GhTb8dO8KMALNk0vDJESlGIslpyQnwkbTvmlLak84qHmIwj
        dYeUJwrEXMctnKaLlqcazcflwlFY6Vc=
Content-Disposition: inline
In-Reply-To: <20230301193403.1507484-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com, peterz@infradead.org, johunt@akamai.com, keescook@chromium.org, quic_sudaraja@quicinc.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 01-03-23 11:34:03, Suren Baghdasaryan wrote:
> Current 500ms min window size for psi triggers limits polling interval
> to 50ms to prevent polling threads from using too much cpu bandwidth by
> polling too frequently. However the number of cgroups with triggers is
> unlimited, so this protection can be defeated by creating multiple
> cgroups with psi triggers (triggers in each cgroup are served by a single
> "psimon" kernel thread).
> Instead of limiting min polling period, which also limits the latency of
> psi events, it's better to limit psi trigger creation to authorized users
> only, like we do for system-wide psi triggers (/proc/pressure/* files can
> be written only by processes with CAP_SYS_RESOURCE capability). This also
> makes access rules for cgroup psi files consistent with system-wide ones.
> Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> remove the psi window min size limitation.
> 
> Suggested-by: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
> Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja@quicinc.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>

with this to fix
[...]
> @@ -1278,8 +1277,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>  	if (state >= PSI_NONIDLE)
>  		return ERR_PTR(-EINVAL);
>  
> -	if (window_us < WINDOW_MIN_US ||
> -		window_us > WINDOW_MAX_US)
> +	if (window_us <= 0 || window_us > WINDOW_MAX_US)
>  		return ERR_PTR(-EINVAL);

window_us is u32 sp the check for <= 0 doesn't make any sense.

>  
>  	/* Check threshold */
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog

-- 
Michal Hocko
SUSE Labs
