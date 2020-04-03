From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 03 Apr 2020 16:08:09 -0700 (PDT)
Message-ID: <20200403.160809.1500394661848619682.davem@davemloft.net>
References: <20200403095627.GA85072@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20200403095627.GA85072@yandex-team.ru>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zeil@yandex-team.ru
Cc: netdev@vger.kernel.org, khlebnikov@yandex-team.ru, cgroups@vger.kernel.org, bpf@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>
Date: Fri, 3 Apr 2020 12:56:27 +0300

> This patch adds cgroup v2 ID to common inet diag message attributes.
> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> cgroup ID) for newly created sockets.
> 
> Some notes about this ID:
> 
> 1) gets initialized in socket() syscall
> 2) incoming socket gets ID from listening socket
>    (not during accept() syscall)
> 3) not changed when process get moved to another cgroup
> 4) can point to deleted cgroup (refcounting)
> 
> v2:
>   - use CONFIG_SOCK_CGROUP_DATA instead if CONFIG_CGROUPS
> 
> v3:
>   - fix attr size by using nla_total_size_64bit() (Eric Dumazet)
>   - more detailed commit message (Konstantin Khlebnikov)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

As a new feature, this should be resubmitted when net-next opens back
up.  Thank you.
