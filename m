From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v5 1/4] mm, oom: refactor the oom_kill_process() function
Date: Tue, 22 Aug 2017 13:06:55 -0400
Message-ID: <20170822170655.GB13547@cmpxchg.org>
References: <20170814183213.12319-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RnJd4D6wxgn819+ziJr/6JvTatrHuX/3PyHYP7ks6Wc=; b=v2ODxE+XMFfN14bnTF/bX6scra
	5mDcQjPyOMi8fLcBFGmLoisf24k7AQ4zdTil02vbQb8julEg3o9UEpuy+aO2w3JQzaFKj+JVLnuEY
	R3zXJhDYrtZLOHmm996XrLU9UOZFZ5qvUDLFwSR27KaybtBQHp1N3HO5m0V5nuZ2W0/s=;
Content-Disposition: inline
In-Reply-To: <20170814183213.12319-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 14, 2017 at 07:32:09PM +0100, Roman Gushchin wrote:
> @@ -817,67 +817,12 @@ static bool task_will_free_mem(struct task_struct *task)
>  	return ret;
>  }
>  
> -static void oom_kill_process(struct oom_control *oc, const char *message)
> +static void __oom_kill_process(struct task_struct *victim)

oom_kill_task()?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
