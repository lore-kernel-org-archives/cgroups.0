Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134224307B9
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950539; cv=none; b=tFJPkLNtLeGuXeIKjv/ffUEkVuPlxi98oOkF58etgkCuutxeqBNvzIXN7FQ9bB4Q0tIm0nVT827oeM07jVcntUM7t6QJ5sYkj23mJQ6HCb81I96qemGdIWrG/T0sYLh5IcVNwS+6NJeIR1W5YvsEKKKJ47Vg92mOjsSlhXL/rjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950539; c=relaxed/simple;
	bh=+UeBgr/3oETL59f/IS+j1IQ/p/NMk8/4+wpi5kr0WO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiWJKVAP6y2j6b0Fo4Nb7zdXwm2L8mDgglDdoUayxJCfHHG2hKi1+9rtkYL3VMR/38aXd8vlNpUy2ZfCi4oFF5SV1txkp0tYsBDMyiBFdGvsskegy/A+Ir5meDilRcY+LeOdXTIkFW3rUVJD1xIrZJ8fYBTZrECXnDSTYKkOEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com; spf=none smtp.mailfrom=readmodwrite.com; dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b=puJYv+lx; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b="puJYv+lx"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-698bf053053so4949422a12.3
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1783950535; x=1784555335; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eXn5kMcR5nKmIutY68IqK6aV4F4qyXcvYDJKsjI+c7U=;
        b=puJYv+lx0ircsYqjjtqYeKjjw3QaB8Ldy/O5KFhnEca2DiViLJlPsx9UDI4miuUG9n
         n1+HQjhV74UP2dhs4ePnJe8UX6IVh70nwxDAEKfqrVYIDdPi4PqpOrlAdH2Gq5Bz9gdo
         NRznjSnLCdHGDx5eGLpdyFrNZeQQFHzvNLqAXS9DaNei2M1ImakCC8t4nAzAtGAvvYhx
         xh/55TQvrD1hLTXBRHUPEanyAT7zt9DlAMVLMT6iQVOdxx8tkMGT42gtMZpNYVDH+1Jr
         T2wXmvkCacsny0KvtSvo4RK5w10JL/S4U43KVV6OyyiP+JS6i6PhaeUQiGf4opnIxe/Z
         hOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783950535; x=1784555335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eXn5kMcR5nKmIutY68IqK6aV4F4qyXcvYDJKsjI+c7U=;
        b=cAh0ohnQwO2d5UkElcrHjtqddhShYCfEeS34vZzpbjYOdF1eWIDkvdpexiuCCkBp6D
         qZ19cN7xMuIW+Zh0tzJo+MVhSESPlsWtV0NoogrDEfgYuZjRVgWcVNf+BucdZvPLhWSM
         oedf/mjSLDQs3+nlj576lCGyNdErUb07BssiNoysYdvtXIqGBwERdsvcpg8wXm3o6sHa
         y9OExTEWvwQbB13orWOUhaCnxOCRTJKlAfbGv00kew6IzpUgXN9/N1wxHmOsj9AWuw1L
         +zese7Mv5HDHa/DkeecLY5VpKjHjRmXBz5rwdRbtCSaaWyNjGbIBK2K5oY3rZLAkEsUD
         b2Qg==
X-Forwarded-Encrypted: i=1; AHgh+RothmsoDEbW8D1cukZ4tfQkBhuBVNDRXcVYt07UzCCRq1fZIYI9hYHavzPPVUSjFzO72bJOTeDn@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmq3yoT6E63IuKMz4rj8HuqYXghK0k98R9HxVP+8VQU9WiaSzB
	kFzbAiIosE+vCKXdFEyhDoj62IzcKBzov+Zt4PAt5Du4oNiTLafcopeBsVyLFXSe5uE=
X-Gm-Gg: AfdE7ckok8vkHP6mjtep4ouwVyAnph5wnWQn++5tufB24a2NNhRNk66XDTL6f4Wy+ct
	LNgZhyOWbV8LCs6g+DvsWhK55IvCB+gj/rtDhTt+2tm6C+5THkx9NWA4Ggu41g+27ntX0uJhQOX
	24yixt0otWZbi2ZDOHS8qTeRl8X49aDbcstCAZQbdJ9qgyeURtki3kmIPQQyFdWc6xEAlkuKDV2
	Gxlh+kYdJDIpjFYWUBGjDlFd3ITwnJvjV7Pr3KbxpL00opQK7Xnid45hDUT6MsWMTmyi5QBTQ+q
	Y9GrzrtEFVjPBtKlzI4DFIuVpnYIv1PsuUX2jdsuPf7OHF0QlIiYqQwiOZDvfwl/Pp46LwmP0kC
	cVge7Y8Wsfdhf8BUrdSMwjVNn/r/I/kDXLpWYY/3MyqeDnvDLSgVkxEHR8b+H6+gfkdwbp/dpLu
	Bg
X-Received: by 2002:a05:6402:3512:b0:699:6415:750a with SMTP id 4fb4d7f45d1cf-69c5f12197cmr3696963a12.23.1783950535377;
        Mon, 13 Jul 2026 06:48:55 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:1f19::319:116])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19d78a08sm16555473a12.18.2026.07.13.06.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:48:54 -0700 (PDT)
Date: Mon, 13 Jul 2026 14:48:54 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>, 
	Changwoo Min <changwoo@igalia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Edward Adam Davis <eadavis@qq.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>, "ziwei . dai" <ziwei.dai@unisoc.com>, 
	"ke . wang" <ke.wang@unisoc.com>, Matt Fleming <mfleming@cloudflare.com>, 
	sched-ext@lists.linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@cloudflare.com, Sashiko AI <sashiko-bot@kernel.org>
Subject: Re: [PATCH 2/2] sched/psi: Shut down rtpoll_timer in
 psi_cgroup_free()
Message-ID: <alTsuUssizMKh0lW@matt-Precision-5490>
References: <20260712174619.3553231-1-tj@kernel.org>
 <20260712174619.3553231-3-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712174619.3553231-3-tj@kernel.org>

On Sun, Jul 12, 2026 at 07:46:19AM -1000, Tejun Heo wrote:
> psi_schedule_rtpoll_work() is called locklessly from the scheduler hotpath
> and can race psi_trigger_destroy() taking down the last rtpoll trigger under
> rtpoll_trigger_lock:
> 
>   psi_schedule_rtpoll_work()        psi_trigger_destroy()
> 
>   rcu_read_lock();
>   task = rcu_dereference(rtpoll_task);
>                                     rcu_assign_pointer(rtpoll_task, NULL);
>                                     timer_delete(&rtpoll_timer);
>   mod_timer(&rtpoll_timer, ...);
>   rcu_read_unlock();
>                                     synchronize_rcu();
>                                     kthread_stop(task_to_destroy);
> 
> The group can then be freed with the re-armed timer still pending, and
> poll_timer_fn() runs on freed memory.
> 
> 461daba06bdc ("psi: eliminate kthread_worker from psi trigger scheduling
> mechanism") deleted the timer synchronously after the synchronize_rcu(),
> which prevented this but raced trigger creation instead: the deletion could
> cancel the timer that a new trigger set armed during the grace period and,
> as creation also reinitialized the timer at the time, corrupt it.
> 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy") moved the
> initialization into group_init() and the deletion into the locked section,
> trading the creation races for the window above.
> 
> Neither placement in the destruction path works. A pending timer firing
> while the group is alive is harmless though. poll_timer_fn() just wakes the
> rtpoll waitqueue and doesn't re-arm itself. Bind the timer to the group's
> lifetime instead and shut it down in psi_cgroup_free(). Nothing can arm it
> by then. timer_shutdown_sync() because the timer is never armed again.
> 
> Fixes: 8f91efd870ea ("psi: Fix race between psi_trigger_create/destroy")
> Cc: stable@vger.kernel.org # v5.10+
> Reported-by: Sashiko AI <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260711000434.36C4A1F000E9@smtp.kernel.org/
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/sched/psi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
 
Tested-by: Matt Fleming <mfleming@cloudflare.com>
