From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Fri, 12 Jul 2013 11:40:36 -0700
Message-ID: <20130712184036.GB23680@mtj.dyndns.org>
References: <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
 <20130711092542.GD21667@dhcp22.suse.cz>
 <51DE7AAF.6070004@huawei.com>
 <20130711093300.GE21667@dhcp22.suse.cz>
 <20130711154408.GA9229@mtj.dyndns.org>
 <20130711162215.GM21667@dhcp22.suse.cz>
 <20130711163238.GC9229@mtj.dyndns.org>
 <20130712084039.GA13224@dhcp22.suse.cz>
 <20130712183404.GA23680@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lCH79IhADsNpvDbWEMFzdX/tluYkQKJ+V6Z7QSIg2To=;
        b=AFcP6NnoWVRSH4sMXgtI52wdbEDlTr8oVpFQBhuBEvXMJd52nAEcaJ++TsbUww76al
         wmlh87W6H7mBHCFCtIwO6d6RWJnoycnARNsfq7gYjGbWWbbcMBaPd8eDIdnXVAWHKJbU
         8JWq2D1cA4M5RY7MD77vb0Bdox1RLsivjW6eNNCHH8rGLrzlmneFi/8pwUzMpUPNy5kC
         AflAOjqpj0OxvycN0kTkkqM61EwmovwhJzA/i9jzmWPPpifiyHT54ErkI5UtZlLFMU4L
         fHKIIKo8gXACteZiOOoP4zhwcItvnaBp9qIHApq1JLyOtOXtV2cdCF9zINmttVyFvwZx
         +ORg==
Content-Disposition: inline
In-Reply-To: <20130712183404.GA23680@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Anton Vorontsov <anton.vorontsov@linaro.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

On Fri, Jul 12, 2013 at 11:34:04AM -0700, Tejun Heo wrote:
> not "bypassing" an existing mechanism at all.  It is an inherent part
> of that model and various kernel subsystems have been doing that
> forever.

Just to clarify, I was talking about two staged object release where
the initial phase shuts down parts which aren't necessary for the
draining stage.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
