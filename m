From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cgroups: Allow dynamically changing net_classid
Date: Mon, 23 Nov 2015 12:15:28 -0500 (EST)
Message-ID: <20151123.121528.2032846721707900257.davem@davemloft.net>
References: <1448050570-1849936-1-git-send-email-ninasc@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448050570-1849936-1-git-send-email-ninasc@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: ninasc@fb.com
Cc: daniel.wagner@bmw-carit.de, "nhorman@tuxdriver.comnetdev"@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, tj@kernel.org

From: Nina Schiff <ninasc@fb.com>
Date: Fri, 20 Nov 2015 12:16:10 -0800

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

Applied.
