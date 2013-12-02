From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Mon, 2 Dec 2013 11:31:53 +0100
Message-ID: <CAJ75kXYKx67VaGYRs1nwataE2ra216qTB9Yks=MRGFN-c_b3uA@mail.gmail.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
 <20131122221839.GD8981@mtj.dyndns.org> <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
 <5292A5EA.1030501@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=mXiHPTbIVjF2mS6PlikJXv0nz+GvMYYsRjFvXiz/T4Y=;
        b=M9xlkk/fd7ZwfXXaMvq5QsYKnppJuUShTNG0svXy21DtbnKgTDC45U+lkoJI7SCJj+
         nw7RwcLRuwdQWbM5jK/k8PppC8MqlOY1eTeYnERdgsBAjHrlNOPE0n7eWZCAq1g78TAH
         QaCrww8BkbX692vwc2QNlVGaO6CNglJGHEutjphjZvgSEAN9Rs/x0eqe2zEQCtpKMr2W
         wxvLK7SLAuugcE6Q0YKCjuD9L7ak2QWgh39CsmMOHG9taVQQmbt7w638Wbj+/NVcpq66
         3sDY78ReoRp5L2T0XvBGS1dm0ZM3wRf2yUubtE7QxmS7bwzvTlT09OYRVpWmYDGfdrHg
         cUCA==
In-Reply-To: <5292A5EA.1030501-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

Hi Li,

On Mon, Nov 25, 2013 at 2:20 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> I'll do this after the patch hits mainline, if Tejun doesn't plan to.

Do you have some news about it?
-- 
William
