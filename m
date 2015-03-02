From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] memcg: disable hierarchy support if bound to the
 legacy cgroup hierarchy
Date: Mon, 2 Mar 2015 12:13:23 -0500
Message-ID: <20150302171323.GM17694@htj.duckdns.org>
References: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
 <421fb6bbff04eb70b8ad82b51efd373f0b4d170f.1424356325.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eRBy/S1i3NoyNf0rDDkzBpEJk/+VDpDlsPGNvbHIRfI=;
        b=n8lF2iXJtOL0XxSqIUqBJ2Wl6nj48KlWNzaVd2AHqkLp3A2ogdWcU37Ja8lbxc43im
         RRZ/ihkzPw6xEfzfCzbc5y/3ozZToQF6TbzkpqHcJJTpKSfVQCopw/ps/+aIFkVLfuOT
         1uHdZCaqbzGKcyaapkzHZSr9Q7n1F/45HGZrp9uQP5CQX7CfoTdz1sywBQUT+d4Kt6BS
         ioWJa+ubWPAFTGaK3MBhhLmYyy8Feo36nbZDfYoDVDOqplxPS0BLf09vby6Wem0naWIU
         aamGEgsmJ05XoycIO6UNZAuRvGYDFpuRutYRgOUK4qUAl0+1xpcoGZerWHoGxYNAOjmj
         czNA==
Content-Disposition: inline
In-Reply-To: <421fb6bbff04eb70b8ad82b51efd373f0b4d170f.1424356325.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 19, 2015 at 05:34:47PM +0300, Vladimir Davydov wrote:
> If the memory cgroup controller is initially mounted in the scope of the
> default cgroup hierarchy and then remounted to a legacy hierarchy, it
> will still have hierarchy support enabled, which is incorrect. We should
> disable hierarchy support if bound to the legacy cgroup hierarchy.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Johannes, Michal, can you guys pick this up?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
