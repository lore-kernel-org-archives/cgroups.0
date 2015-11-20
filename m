From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] cgroups: Allow dynamically changing net_classid
Date: Fri, 20 Nov 2015 15:40:20 -0500
Message-ID: <20151120204020.GA1574@mtj.duckdns.org>
References: <1448051499-1885574-1-git-send-email-ninasc@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q38n3aJNe46Fe2pPC8S/ZsfDT49/sWzUhaZNKoB6FRA=;
        b=vP852uRiUwDehwhr5+GJfAFncDzfiyKiIxeGJGGjdLARwGkDw60kFIPfqZORP2RP00
         jrdpzvdDIyQ79sFv1DN1gLWK2/jY+vzYQcueOeTJWVR32PJu8v/UKGxk8/cABfMCrEis
         TgIeq+Db5+lHy35Ay6o8oef+mRllUkA34ZK+0PRlSoZ2VnQYbWj8p9BylJSSmB9Yaw2C
         2yK4ELdJhcb1n63+FVJciUWRKk5KxOnuLLONfJU8TXbt5pPS6q6TlyOnIh/xvWRVA6B/
         C1trdTvcVp4/qV6MAhBPvBDY8TUdoEnWRzvGIxYgPt2VYM2y7I/+TcMpKQwkMHb2PT5w
         Ssxg==
Content-Disposition: inline
In-Reply-To: <1448051499-1885574-1-git-send-email-ninasc@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nina Schiff <ninasc@fb.com>
Cc: davem@davemloft.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com, netdev@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Fri, Nov 20, 2015 at 12:31:39PM -0800, Nina Schiff wrote:
> The classid of a process is changed either when a process is moved to
> or from a cgroup or when the net_cls.classid file is updated.
> Previously net_cls only supported propogating these changes to the
> cgroup's related sockets when a process was added or removed from the
> cgroup. This means it was neccessary to remove and re-add all processes
> to a cgroup in order to update its classid. This change introduces
> support for doing this dynamically - i.e. when the value is changed in
> the net_cls_classid file, this will also trigger an update to the
> classid associated with all sockets controlled by the cgroup.
> This mimics the behaviour of other cgroup subsystems.
> net_prio circumvents this issue by storing an index into a table with
> each socket (and so any updates to the table, don't require updating
> the value associated with the socket). net_cls, however, passes the
> socket the classid directly, and so this additional step is needed.
> 
> Signed-off-by: Nina Schiff <ninasc@fb.com>

Acked-by: Tejun Heo <tj@kernel.org>

This was broken from the beginning.  Thanks for fixing this.

BTW, this will cause a context conflict with the cgroup2 match
patches.  I'll update the patchset once this lands in net-next.

-- 
tejun
