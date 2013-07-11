From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [OFFLIST] status of devcg
Date: Thu, 11 Jul 2013 10:11:40 -0700
Message-ID: <20130711171140.GC10195@mtj.dyndns.org>
References: <20130710184655.GB16979@mtj.dyndns.org>
 <20130710195001.GW14011@redhat.com>
 <20130711093405.GC2377@redhat.com>
 <20130711155106.GB9229@mtj.dyndns.org>
 <20130711160532.GA14909@ac100>
 <20130711171037.GB10195@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iQ8JJaIBwuZNYaiUUcsINziXtYTZqSVOWC/tNfPiw4I=;
        b=Mvi0PTZv2n8oYotgdwQI5NAnB34qEX1kTLBN5IsTMbYP/cUVSmSOaNkWi1RLOOrSD6
         cAtLovdNoO9sF2p6ODXebuZd29HIlrjlfvfEmaai+Jv8irPIhY4gu2Sh+jRikEJo2WRw
         GWmmTvpJkSxCSj0RglkdyRVgmu4fGSpwWGo8LavDeQc7onb2Ckl++ooNUYPjf8VeOvjA
         +vnN4E94Hutb/MwshxYXTDdk0xWL3F/eMm6MyJg5hmiCN6VB1Xl1zRZ4POdt/0ygAEer
         AK9KI7mn4ED7Uu8wR0zznAIb4pRGUYkD7xz6Rkd4eiZ8JYhp0VvhnpaNmiNabjeR4Pwf
         SG/w==
Content-Disposition: inline
In-Reply-To: <20130711171037.GB10195-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 11, 2013 at 10:10:37AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 11, 2013 at 11:05:32AM -0500, Serge Hallyn wrote:
> > Is there something in particular you want to accomplish for which the
> > current rules do not suffice?
> 
> Yeah, a cgroup changing its rules affecting the descendants
> irreversibly, which is nasty and makes it tricky to implement
> automation on top or implement proper cgroup migration, so I asked
> Aristeu whether he could implement cleaner behavior for unified
> hierarchy.

Ooh, BTW, the other controller which has similar behavior is cpuset
and that one is gonna be updated too.

Thanks.

-- 
tejun
