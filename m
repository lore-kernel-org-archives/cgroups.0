From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Fri, 22 Nov 2013 23:54:49 +0100
Message-ID: <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com>
 <20131122221839.GD8981@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=Pc8KAol9BsEaZ/n6W7lNAyfdAL1V7oLpWRgm6aYl14Y=;
        b=pwuC9uNwesqrkt0v0eIIStAro2zLXVNlzVWA4XF5fbxFzYPsxk+/vIN0T+ovfntgyh
         3/WuzASWJpYkrGx8JbmzBn4kk/tzP0DympeLDXOABunWE1iNwigkyluqrDY0kbdBnGX3
         1Hc2L10/x8UVtJX6/GSLzGS17OaU5G+NEjrmoQT1Qe0KBY6ORN1cGEflhxQdRP1J1Bp0
         mGaJ8QBRjuKE0rJu/Z4Y3gwBAEz5B8A6ki2D/OaXWp3M+eSbUXzLs/JXpq9B3H3zDnEj
         XVjRDIp4td1dGGnzapy9otn0ouMj4N0QR7F69/ptoGQWn+akE8JKhVKYmBgSoZCw0ooS
         YIUQ==
In-Reply-To: <20131122221839.GD8981-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

Hi Tejun,

On Fri, Nov 22, 2013 at 11:18 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Just applied to cgroup/for-3.13-fixes w/ stable cc'd.  Will push to
> Linus next week.

Thank your for your quick reply. Do you also have a backport for
v3.10.x already available?

Best regards,
-- 
William
