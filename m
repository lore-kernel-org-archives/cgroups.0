From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] vmpressure: document why css_get/put is not
 necessary for work queue based signaling
Date: Fri, 12 Jul 2013 11:48:36 -0700
Message-ID: <20130712184836.GC23680@mtj.dyndns.org>
References: <20130712084039.GA13224@dhcp22.suse.cz>
 <1373621098-15261-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9483TizRtnp5a9LNZey1gGXOSma+tgmGnGaO57nTESQ=;
        b=ZM2kwp2EfDh2BNucr8pxurAFbNI4KctEEybiSwTYMr0X8GVcqJHJgh9y8yjJgBufXa
         Q6Ik5URZqFnMHsfxOJAS3/t55m94atX8u0XJbZn3/wNweL/HdVDFQas1KiPwlV32Miv0
         HSm+Ksmw99mQDzIbW1MWc1J8clPpdf+wVRIVulcJub/p4XuN+U/E6r+Q0VetT3Aw072m
         loCLZMo4Ze4rdcj5PFj++lDtG+XDkyy3IYxE2lCm02MHPtCYlKtQDo2t+w3jkJEozOyU
         3s64VamaBSu7pO4hvSGcvz8Q7HEPVIgsAabN14QCXL7GgCjDxDbr3FcEhfm58EEra/5C
         +vYA==
Content-Disposition: inline
In-Reply-To: <1373621098-15261-1-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Anton Vorontsov <anton.vorontsov@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org

On Fri, Jul 12, 2013 at 11:24:56AM +0200, Michal Hocko wrote:
> Cgroup events are unregistered from the workqueue context by
> cgroup_event_remove scheduled by cgroup_destroy_locked (when a cgroup is
> removed by rmdir).
> 
> cgroup_event_remove removes the eventfd wait queue from the work
> queue, then it unregisters all the registered events and finally
> puts a reference to the cgroup dentry. css_free which triggers memcg
> deallocation is called after the last reference is dropped.
> 
> The scheduled vmpressure work item either happens before
> cgroup_event_remove or it is not triggered at all so it always happen
> _before_ the last dput thus css_free.

I don't follow what the above has to do with ensuring work item
execution is finished before the underlying data structure is
released.  How are the above relevant?  What am I missing here?

> This patch just documents this trickiness.

This doesn't have to be tricky at all.  It's a *completely* routine
thing.  Would you please stop making it one?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
