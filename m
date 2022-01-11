From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Tue, 11 Jan 2022 10:09:52 -0800
Message-ID: <Yd3H8Hea6dBlkzeW@carbon.dhcp.thefacebook.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=U1FW9R34RRwKTnQuKIhL5KdS/m+UI9gJ902cIt8RJog=;
 b=EXJOQDz5wR0jxE7ikPyQIN8CAV5Yhr9J83RgymFyYXLvKppFmsXV1F6OEwyUlKCNL7/q
 ZFuTTaQCJp4lDfPp7WF/4hlwIKc8wlyvBPkxpxG50v6lH68bCgaK+wNWlkHxtDz+jj83
 3NZPQKSKo1RODftCZHccDwEpCld6YGMNS2g= 
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 01:03:01AM +0000, Wei Yang wrote:
> The parent we get from page_counter is correct, while this is two
> different hierarchy.
> 
> Let's retrieve the parent memcg from css.parent just like parent_cs(),
> blkcg_parent(), etc.

Does it bring any benefits except consistency?

> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
