From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Sat, 29 Feb 2020 10:43:00 -0800
Message-ID: <20200229184300.GA484762@carbon.DHCP.thefacebook.com>
References: <20200219183231.50985-1-balejs@google.com>
 <20200229005131.GB9813@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=J+jPrk2kzt4C/MV7AgapNv9fM22p36mZR7nGr6Zb0rw=;
 b=ABuxQ+ufv/wrth11Ybfr9N459riaiArs7qbRmlBZmo2Y9jyUDSo+AJmyORpPxhS5YtbF
 oIQS+u1F/12RCXKBybvPpc2rCKxj2YrRhQsFFPJJjGSJf5tGrg2MwIFTtyJdRr8RdeSj
 yDvnOk7ldBC5UO7gvZVBrWoX6CeQYlqabDE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+jPrk2kzt4C/MV7AgapNv9fM22p36mZR7nGr6Zb0rw=;
 b=VdDY/5xKVbkOKEC1zoDii2KijFNCoAcYl9qqW4D9c+PSiiTcpjcfwEOr5Hsjz+u+JKqfEdTn5ldFKSLoDuj2pJRPXQPr7eK18g/s7zfzWxtzoYHmJ1OeWErcZCJWhl/Od5pZaJwWE1uHhflMxo/BQDSOHCChqZ3nugfiTd/4eoM=
Content-Disposition: inline
In-Reply-To: <20200229005131.GB9813-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Ballesio <balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Feb 28, 2020 at 04:51:31PM -0800, Marco Ballesio wrote:
> Hi all,
> 
> did anyone have time to look into my proposal and, in case, are there
> any suggestions, ideas or comments about it?

Hello, Marco!

I'm sorry, somehow I missed the original letter.

In general the cgroup v1 interface is considered frozen. Are there any particular
reasons why you want to extend the v1 freezer rather than use the v2 version of it?

You don't even need to fully convert to cgroup v2 in order to do it, some v1
controllers can still be used.

Thanks!

Roman
