From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] netfilter: implement xt_cgroup cgroup2 path match
Date: Fri, 12 Feb 2016 11:05:58 -0500
Message-ID: <20160212160558.GE3741@mtj.duckdns.org>
References: <1449527935-27056-1-git-send-email-tj@kernel.org>
 <1449527935-27056-9-git-send-email-tj@kernel.org>
 <CAMXgnP7Eue2NQrUcRSNgM8NJT5XOscPWwqVkuh7LnwQn-1oQ_A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=r+SJkM3IZ9P6iPyrjR8omWJN2Rovh55u3k8oBTNdGkE=;
        b=XZNy2UxCPyYBUeaiuvPjsFhTUAuFB6agJ+PIyji/d7dnLbd9q0R7U5pfC5f+TGrnRa
         vPRAvgjzzk1biUg0D8fB+CHEu6r3z4hsZihUdTnKZJHF2aUUu3gMJGNTF5JEDe3aC3qO
         3wPwjJMHnc/r9cZ6re6FLd99cAdWuBq3bStq0ngrYlPJ5eFMfZfhgo7iL6roxdqhTHgF
         pUQfaVhvDFa267QyjjiOEdpAvQW4HFykKhk/NBE0/8OgFhXtUGewZit6marDmrAlxapg
         ZTgIlrK/Jjl4zmeVkRTzaUPgKR9BNEd1vgqc2QpklZg0Qt3fuPeMMrVUQCL7B+GO2mN+
         dUoA==
Content-Disposition: inline
In-Reply-To: <CAMXgnP7Eue2NQrUcRSNgM8NJT5XOscPWwqVkuh7LnwQn-1oQ_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, ninasc-b10kYP2dOMg@public.gmane.org, Jan Engelhardt <jengelh-9+2X+4sQBs8@public.gmane.org>

Hello,

On Fri, Feb 12, 2016 at 01:10:18AM +0100, Alban Crequy wrote:
> Is there any plans to implement a similar cgroup2 path match in a
> cgroup classifier in tc?

That'd be great.  I wanted to but couldn't figure out the heads and
tails after staring at the code for half an hour.

> I wonder if it will be possible to use cgroup to classify packets in
> tc without net_cls.class_id in cgroup2.

You can still match against cgroup v2 path using xt_cgroup and then
mark it and then match that from tc, which isn't ideal but works.

Thanks.

-- 
tejun
