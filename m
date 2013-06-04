From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: restructure mem_cgroup_iter()
Date: Tue, 4 Jun 2013 13:51:23 -0700
Message-ID: <20130604205123.GH14916@htj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-3-git-send-email-tj@kernel.org>
 <20130604132120.GG31242@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M46VOQXK7IARvEMwK6oc19iHKEsGMxSleLdhpmwJLXQ=;
        b=t5Z/C0jlvFqwDkfhE4eL+dHlE1fE9eXIk9zJyNCs7g1A66wMZwsmClef/9ZFWu4Z/N
         nO8f0naOz5qIWtsHnQVIu/wm501Ub1yJ1btW4WGCmocPxXdsX1S8cEoiwr3gYnL9WCEE
         TKxYhPYrGfmgvm63lCdj2fv2PHbOC4QrZsA5djTV/w2KZiFIZClY2l63Rm+xp5cnlRTR
         CHA2qFSkjeNninXWxKEbbDzHoMX1c6wec602+tif11MKjytokI8CdS542LNNJ2XL4zVO
         RiTW/s+LSDRIUa+WfGcsvtrbIDnPQIK7P+lFiYjIy4q0vQUG0nXZibPHtyKjHq0ZC/0U
         coaQ==
Content-Disposition: inline
In-Reply-To: <20130604132120.GG31242@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On Tue, Jun 04, 2013 at 03:21:20PM +0200, Michal Hocko wrote:
> > +	/* non reclaim case is simple - just iterate from @prev */
> > +	if (!reclaim) {
> > +		memcg = __mem_cgroup_iter_next(root, prev);
> > +		goto out_unlock;
> > +	}
> 
> I do not have objections for pulling !reclaim case like this, but could
> you base this on top of the patch which adds predicates into the
> operators, please?

I don't really mind either ways but let's see how the other series
goes.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
