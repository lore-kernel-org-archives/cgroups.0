From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Tue, 31 May 2022 07:19:31 -1000
Message-ID: <YpZOIz/CbQs+aWF6@slm.duckdns.org>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
 <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
 <e74e03f1-cb54-b158-a085-2965fd088d1d@loongson.cn>
 <YpVo4XiIDu68w40Z@slm.duckdns.org>
 <fbb820c5-dbcb-0f00-c365-d3c57ca27edf@loongson.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TifpfMoDlGxLgqXOhSyuPYzc2dB196x72BY7fE2wUZk=;
        b=NX1qO31Nmah+xqNr6YcOYiJumlgg7+QsK1AYsMYODbBoAwGGqI4wTQpZGnBMJ+E9yF
         mzTLek8eUCaBAtCzBt0RCWIu1CNWH0oAjRLN1kZ4+UHLZI9Uj2OEHZUSnR+exDoYAwe1
         0H1CEqjc+D9COgvl3QskBuO6vXXcqsLYAkQWawKc6B6G3xXMlv3jZpOLFH6JJWkBdK7/
         b7chkKFHxD9s1OhJshxp5APXdWd4Jso6xosmRmVJ75DCO3s3qNoznXFYBrCvScciW03j
         IA9JfblnJHNiesH0Xs+VMZxl4yJxnqC6svpsDJklGI3VFA3jjtYqAHp0qFi1iTtiy0pY
         S27Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fbb820c5-dbcb-0f00-c365-d3c57ca27edf-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, May 31, 2022 at 11:49:53AM +0800, Hongchen Zhang wrote:
> Yes, the problem would disappear when add some reasonable delay. But I think

It'd be better to wait for some group of operations to complete than
inserting explicit delays.

> if we can increase the MEM_CGROUP_ID_MAX to INT_MAX.Thus the -ENOMEM error
> would be never occured,even if the system is out of memory.

Oh, you're hitting the memcg ID limit, not the css one. Memcg id is limited
so that it doesn't consume as many bits in, I guess, struct page. I don't
think it'd make sense to increase overall overhead to solve this rather
artificial problem tho.

Maybe just keep the sequence numbers for started and completed offline
operations and wait for completed# to reach the started# on memcg alloc
failure and retry? Note that we can get live locked, so have to remember the
sequence number to wait for at the beginning. Or, even simpler, maybe it'd
be enough to just do synchronize_rcu() and then wait for the offline wait
once and retry.

Thanks.

-- 
tejun
