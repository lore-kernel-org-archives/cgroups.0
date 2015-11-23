From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/9] sock, cgroup: add sock->sk_cgroup
Date: Mon, 23 Nov 2015 10:48:09 -0500
Message-ID: <20151123154809.GD3049@mtj.duckdns.org>
References: <1448122441-9335-1-git-send-email-tj@kernel.org>
 <1448122441-9335-8-git-send-email-tj@kernel.org>
 <56530E4B.4090209@bmw-carit.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uvfyYggeHeMhKgONSGYqvPTKFUtSWw1gMUbxQR7vGb8=;
        b=Yepv2kZQuu5oFFhbXP852WOy1n8MuapfZjrucmN1qLQIrql/d/QSSBeMdTmYPf04GG
         AfS/fT0qwQOgbEU3Yvjk2wYmnuelRtJ7/KwP9lqznsI170iq+pBTzJZ25r15BwXU/sXT
         mIZ7sYwzrXhbepJIWOif1oInU4oTCIQ9Y679J1ueaEBEm63Qflb7HZwo7/wB0WDtfWZc
         vKzskFM+kdfqFCzzTQGxipQR8MmZQfAJllQlF8dV2PkVuUevjTtVpw82siX1zYdb9Eyc
         P16veEXq36o6vY2gRbDDjuqE88sj5odmscWqRD+XDBxe+uyVGvkkbXfGCpMw9zGWx2jQ
         tttg==
Content-Disposition: inline
In-Reply-To: <56530E4B.4090209-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, ninasc-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Nov 23, 2015 at 02:02:03PM +0100, Daniel Wagner wrote:
> On 11/21/2015 05:13 PM, Tejun Heo wrote:
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
> > Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> I did a quick test and for new connection the cgroup2 match worked as
> expected. For an existing connection I wasn't able to trigger the match.
> 
> It is quite likely I do something wrong:
> 
> 	ssh into the box
> 	# mkdir /sys/fs/cgroup/test
> 	# echo $$ > /sys/fs/cgroup/test/cgroup.procs
> 	# echo $PPID > /sys/fs/cgroup/test/cgroup.procs
> 	# iptables -A OUTPUT -m cgroup --path test
> 
> Should I see matches with the existing ssh session?

Socket is associated with the creating cgroup and stays associated
with that cgroup until it's released.  Migrating the process doesn't
change the ownership of the sockets it has created.  This is in line
with how other stateful resources such as memory are handled in
cgroup2 hierarchy.

Thanks.

-- 
tejun
