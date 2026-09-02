Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD0A39EF0B
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346917; cv=none; b=XEx9UvNYNWeeV86DPxZKbFQNDZ/q74XCZd+j4hgN6okgHax9+EdZWFDVgDZTo3gc056ygT4ki30FwNN0c4TFNJkor2rVZz/+yiQ29DrYGHezJ+vaTOAc+tbFH0iHi23NqvfgdifudWHHWcnBp8B0ohcO6fySG5hwiaVHoX7QEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346917; c=relaxed/simple;
	bh=P4tTzOwe9RdY9+G+XtbZm/9HF/zg96Akx4Mdzhc6MuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9gAd1nXw0YvpYK/s5RWMocLaccHJcBTaWCkv52KXumtIFmcakBcIIem7FPMQjgXbwsHeP8ogCa2v6J1S73YRnn3IAhxRgFA2z2ETxFnANlbgJY7Sq97Li9j/iUMxfzUFdvE3xhmygdTxgw5kfgmNtqtrJ/qUiFLMQwTsfujguk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FS/mRdjS; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FS/mRdjS"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b4a0e5aefeso874004e87.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 04:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788346913; x=1788951713; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MsJAUkYPcrI81+ZTJ2fux+QPTEZOfMVHD7vmgI0FX+Y=;
        b=FS/mRdjSr3M57M5x5sO7Kysc2M+ZiS8GDnTEcSIW/vyGSLnBb4mY2rGBuZp0eVz6dv
         K17JU6rT6uFgMawNN0USiUrtSm7Gbev2DKvdFcHILPOxScte4NdGXwy2ykNVv/DhiU3O
         v+ChL3fX79DXrTfrESw5Yj8NlNw9maxYZwAinzznCCE9RTihnFW9J+D6Eks6GJOXL6Pd
         KAdUj82xCfSeidlDS1dawihC90Tdngn2Klkj4G0Ce5gIHNYxVqeXZIstYMBqOepQx0wB
         vpmg/tlq+Dd7IG+MEPObaFtbvwj/AfgKt/1xM9IZ67mnysMx6CS7XTdGa9NnYPUo2Oy0
         Pquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346913; x=1788951713;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MsJAUkYPcrI81+ZTJ2fux+QPTEZOfMVHD7vmgI0FX+Y=;
        b=Yd6G2Sqk/0ue+du338xLfUy3Dn7PTBRaLLWbJIZWLr1n0UXBtjwnpaSbe3rgm15r4I
         Vd1vaQqGY2AMES2WWX6IZKXNt+j6CFtVu6p47puGLPwu7OUqQO7Wd+2zTtWWq6LtCL+R
         5tpDIfHp9/fjTX+Yb7HuRd8k1O3XFXLXonrMMQNUXF/REYnSUPXwr1h6KUi26ujTZCam
         m5uycYoBFFYWYtwpscXvcQwWByxe4iUeimTbe9o+RcFQRT+tXsU3Dxg002JhTOpWZSNl
         B8TCqylzaxc7nVS37FkBe9w6mYU3oViRpFh+tdBJUnPVMRiBdxp/XgeUyb/4IS2dSHfw
         RRdQ==
X-Forwarded-Encrypted: i=1; AKwUvBzkxQThwERPshWQxSQzB5nwUCuwID5oMBrsj6+JSG7EYWwmThBzVGnQc336jnPB9Js0y0U2cocL@vger.kernel.org
X-Gm-Message-State: AFuF++nhM1rzLtpVDTh41nyPTDgBMOhP3hhDD05iVBNvNQZNmjU8onB4
	WPRG+qL6mAZDxUkJ2oVKx6OiTO6F4G/bjGN+xCO1Hm7IgaWyVKDSHqW6
X-Gm-Gg: AYBFou2qQZ4IegZgTD0g1uXpU+HvaOzbK+hi0t513/q/YFbLoYuyvbMFHocyRnPM1gF
	HuYUoSlanRiVpxgWrvA9YKu7lOrrbBkUOx7jF9VhmrH/ET9ugBuv+fX/DifY1v5GA5PNJgxb07i
	cLw9Wb2MQFbf6SyxD7GwxWZSNCO358iRb+qZlZUXSqrhCIUSZLsV/D2r64ZTPWRkqGi2cjBcAYV
	YrPR77gVt6OvDw6bL2tyryTnj6mz5iM00hFZnQ/0L99Kl7MwbDvjES2tN3X5FIEO5hGtBZ6aPsb
	VceD3J/xqHSXCp5Ld6b4kStAnQveofI+fa7q1sbqpW1rJLhaGmomC6fnthJHgc12GwmloE2P8j2
	BXGFrubgMgBoJOFlc45o76fjun9DVWyS80OY1e9zOzGs/73Uo56oNwiSy+Z06zr6f+zFvdwul6n
	6SsbqAKoRKF2Q+9l7CWc31Kk9Qld12lojXKA==
X-Received: by 2002:a05:6512:1319:b0:5b4:fdc3:d3f1 with SMTP id 2adb3069b0e04-5b6086949edmr1155610e87.18.1788346913292;
        Wed, 02 Sep 2026 04:01:53 -0700 (PDT)
Received: from elende (elende.valinor.li. [2a01:4f9:6a:1c47::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b606ba1481sm508702e87.61.2026.09.02.04.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 04:01:51 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date: Wed, 2 Sep 2026 13:01:51 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Michal Koutn?? <mkoutny@suse.com>, 1144314@bugs.debian.org
Cc: Noah Elias Feldt <N.Feldt@mittwald.de>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Dan Schatzberg <dschatzberg@meta.com>,
	Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: Bug#1144314: refcount_t: addition on 0; use-after-free,
 regression from 260fbcb92bbe ("cgroup: Move dying_tasks cleanup from
 cgroup_task_release() to cgroup_task_free()")
Message-ID: <apgCH7zgmygyWl7g@lorien.valinor.li>
References: <FR6P281MB6118B1A758F3278BC9BA795AF0DB2@FR6P281MB6118.DEUP281.PROD.OUTLOOK.COM>
 <178682274912.1759826.11422695267451330087@eldamar.lan>
 <FR6P281MB6118B1A758F3278BC9BA795AF0DB2@FR6P281MB6118.DEUP281.PROD.OUTLOOK.COM>
 <aoh7Kbt_WbUcfUxh@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoh7Kbt_WbUcfUxh@localhost.localdomain>

Hi Michal,

On Fri, Aug 21, 2026 at 06:59:26PM +0200, Michal Koutn?? wrote:
> Hi Salvatore,
> 
> thanks for the nice report and sorry for not so prompt response.
> 
> On Sat, Aug 15, 2026 at 09:41:14PM +0200, Salvatore Bonaccorso <carnil@debian.org> wrote:
> > With an additional reproducer provided by Noah, I could bisect the
> > change down to 
> 
> Good job.
> 
> > 
> > 	commit 260fbcb92bbeacfcd050410fdc2d24ab15044400
> > 	Author: Tejun Heo <tj@kernel.org>
> > 	Date:   Tue Oct 28 20:19:16 2025 -1000
> > 
> > 	    cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgroup_task_free()
> > 
> > 	    Currently, cgroup_task_exit() adds thread group leaders with live member
> > 	    threads to their css_set's dying_tasks list (so cgroup.procs iteration can
> > 	    still see the leader), and cgroup_task_release() later removes them with
> > 	    list_del_init(&task->cg_list).
> > 
> > 	    An upcoming patch will defer the dying_tasks list addition, moving it from
> > 	    cgroup_task_exit() (called from do_exit()) to a new function called from
> > 	    finish_task_switch(). However, release_task() (which calls
> > 	    cgroup_task_release()) can run either before or after finish_task_switch(),
> > 	    creating a race where cgroup_task_release() might try to remove the task from
> > 	    dying_tasks before or while it's being added.
> > 
> > 	    Move the list_del_init() from cgroup_task_release() to cgroup_task_free() to
> > 	    fix this race. cgroup_task_free() runs from __put_task_struct(), which is
> > 	    always after both paths, making the cleanup safe.
> > 
> > 	    Cc: Dan Schatzberg <dschatzberg@meta.com>
> > 	    Cc: Peter Zijlstra <peterz@infradead.org>
> > 	    Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > But there was the suspect that the matching commit might be
> > d245698d727a ("cgroup: Defer task cgroup unlink until after the task
> > is done switching out").
> 
> I see that after 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from
> cgroup_task_release() to cgroup_task_free()") it may be possible that
> tasks on the dying_tasks list may drop their ->usage to zero (since the
> actual unlinking only happens in __put_task_struct).
> Most often those would be skipped due to PF_EXITING except for the case
> of thread group leaders (which the reproducer stresses) whose refcount
> apparently can drop to zero after task->signal->live > 0 made them
> iterable :-/
> 
> A band-aid fix could be to use tryget_task_struct() in
> css_task_iter_next() (I got that hint from a LLM) and "skip" zeroed
> tasks. I see that commit fbe3fb103596b ("sched_ext: Replace
> tryget_task_struct() with get_task_struct()"), assumes the iterator
> always succeeds in obtaining the task reference (which was the
> justification of tryget removal). I expect that sched_ext should still
> be fine if dying_tasks with zero references are skipped. (What are they?
> Tasks which literally no one should be interested in and they're only
> waiting for __put_task_struct_rcu_cb() to be called [*]).
> 
> (I'm calling that band-aid because it'd resurrect usage of
> tryget_task_struct() and it keeps the dying_tasks list a weird place to
> be. If anyone has a better idea?)
> 
> The commit d245698d727a ("cgroup: Defer task cgroup unlink until after
> the task is done switching out") seems a reasonable separation of the
> stages to me.

Thanks a lot for looking into this problem. Is there something Noah or
I could test? 

Regards,
Salvatore
