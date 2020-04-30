From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net-next 0/2] inet_diag: add cgroup attribute and filter
Date: Thu, 30 Apr 2020 12:55:06 -0700 (PDT)
Message-ID: <20200430.125506.1341002176317746009.davem@davemloft.net>
References: <20200430155115.83306-1-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200430155115.83306-1-zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Date: Thu, 30 Apr 2020 18:51:13 +0300

> This patch series extends inet diag with cgroup v2 ID attribute and
> filter. Which allows investigate sockets on per cgroup basis. Patch for
> ss is already sent to iproute2-next mailing list.

Ok, this looks fine, series applied.

Although I wish you could have done something like only emit the cgroup
attribute if it is a non-default value (zero, or whatever it is).

Every time a new socket attribute is added, it makes long dumps more
and more expensive.
