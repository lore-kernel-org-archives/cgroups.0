From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/51] memcg: add mem_cgroup_root_css
Date: Thu, 18 Jun 2015 13:49:30 -0400
Message-ID: <20150618174930.GA12934@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-7-git-send-email-tj@kernel.org>
 <20150617145642.GI25056@dhcp22.suse.cz>
 <20150617182500.GI22637@mtj.duckdns.org>
 <20150618111227.GA5858@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KJ63fnuoGLacMQiXJx2ehTai5RImBG5dBljH6wbD4OQ=;
        b=li1pvDVhRpZbHQj774wB3mzG0Uf1lNpntwqBxzFLngxj3YwknHR5rHEMMMz5jWKKqE
         sBVzit6rvOdQqDjMMYhRkO9aptgAI8cplj8omRzgTrjp8EMhcVO2jTTqk0XruPq+CFeX
         rIdMO62Tpa709rtTTSkbP3hjpBrP6vrrMUzNFCbsX7t+iz+nuiv/M8lTB/J1BuhBOlz9
         NRslEVixwQmwKsjDKv2kkCRe3SVZKVEucJoi4tc23rfUvd/fh9NtlS2GkjT1HcH75P+W
         r94TJOO8wL0PD+zoF+k9V+WDNkIXDtmz9JfJSS/C0E/U5XjDpXXKzd6NlaulPVluMx/x
         +Ivw==
Content-Disposition: inline
In-Reply-To: <20150618111227.GA5858@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello, Michal.

On Thu, Jun 18, 2015 at 01:12:27PM +0200, Michal Hocko wrote:
...
> I see and yes, it makes some sense. I just think we can get rid of the
> accessor functions when the struct mem_cgroup is visible and the code
> can simply do &{page->}mem_cgroup->css.

As long as the accessors are inline, I think it should be fine.

> I have tried to compile with !CONFIG_MEMCG and !CONFIG_CGROUP_WRITEBACK
> without mem_cgroup_root_css defined for this configuration and
> mm/backing-dev.c compiles just fine. So maybe we should get rid of it
> rather than have a potentially tricky code?

Yeah, please feel free to queue a patch to remove it if doesn't break
anything.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
