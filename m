From: Tejun Heo <tj@kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Tue, 17 Dec 2013 08:14:15 -0500
Message-ID: <20131217131415.GG29989@htj.dyndns.org>
References: <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
 <alpine.LNX.2.00.1312162300410.16426@eggly.anvils>
 <20131217131119.GD28991@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=t7JpwJqPjBeS2NMDnzz2HtxMZmlPhrveabQY7gD9OEg=;
        b=Nx88xWnRIrzW/PDLjucm60sc/t3VdyQLrwIHRWuPSzwxEb34RsmYYP/fHMD5HC+2Ed
         lfoDoozukTPllFdX7m+Mrwuj0rCDkOu3B2ejuxTuQIsPkpvidIk6VJojic3CQKlXMvgN
         0Qzv6GZsDmU8iVqSmBGXHrLueFYZqD8SRYIq0/BETSigV5HaXEtd86dOoaBNBnR2MfJK
         +OAzKv30gTX8IfSn4q3wYxEVvEGLDJ+4J8YCs4M78opZgHe/HABXX7v1eTPXZ9T6YeO4
         7KoK06I+uEHr/ARFrxUqVQ2OyRBIy7Ra99yx7jDoZx6omRjFsB3+BC0dZWYhusoHuliR
         u0Ig==
Content-Disposition: inline
In-Reply-To: <20131217131119.GD28991@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:11:19PM +0100, Michal Hocko wrote:
> And sorry for distracting you from the css based approach. I have
> totally misinterpreted the comment above idr_remove.

Heh, you actually interpreted it correctly.  I was the one confused
when moving the id to cgroup.  I should have just converted css_id to
idr based per-subsys id in the first place.  Sorry about that. :)

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
