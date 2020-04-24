From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Question about BPF_MAP_TYPE_CGROUP_STORAGE
Date: Fri, 24 Apr 2020 09:25:57 -0700
Message-ID: <20200424162557.GB99424@carbon.lan>
References: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+MjBi82/SVt47pYOBEgSUwbeLKitEqMEiLJsqmlpMMk=;
 b=SVl1+DgG1i++y7260lhiL9e79Ftyl/wQMeTJU4bB87YQLqZEg5J1CK2oO/yoWj/S9s81
 jyfI8cKpsG/SnG7TaA8UwOUHj4ZcWCuVZSShluYF7Nfo6y3Ebb5TdR5HlBU2YNUX2fgC
 Z4dqvu+SebrNfVP9C/jb1+BU6yy7uzwByDM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MjBi82/SVt47pYOBEgSUwbeLKitEqMEiLJsqmlpMMk=;
 b=HrL5+Q6KAqN6eQKnB53EJVXUO9C9zkMkWy0TsyMXlkME8nXwMQUr77vbbuHTf28ocq/kItcFIFsJ91WFI45FUMTTXl0X0cNxp2VEJxHpAQjlJo8q3hk7QKfHg9FDk2M/QbvEfGe/qnk2bN0+SKsC6uyk2nDvjmzJRaZpcXTfSKY=
Content-Disposition: inline
In-Reply-To: <CAOWid-dSF0X3pa6ud2-ndYzJdohuOBewfcEZcG7pQ8q=fZh14g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 24, 2020 at 12:17:55PM -0400, Kenny Ho wrote:
> Hi,
> 
> From the documentation, eBPF maps allow sharing of data between eBPF
> kernel programs, kernel and user space applications.  Does that
> applies to BPF_MAP_TYPE_CGROUP_STORAGE?  If so, what is the correct
> way to access the cgroup storage from the linux kernel? I have been
> reading the __cgroup_bpf_attach function and how the storage are
> allocated and linked but I am not sure if I am on the right path.

Hello, Kenny!

Can you, please, elaborate a bit more on the problem, you're trying to solve?
What's the goal of accessing the cgroup storage from the kernel?

Certainly you can get a pointer to an attached buffer if you have
a cgroup pointer. But what's next?

Thanks!
