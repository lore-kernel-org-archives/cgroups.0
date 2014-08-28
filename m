From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] cfq-iosched: Add comments on update timing of weight
Date: Thu, 28 Aug 2014 08:30:46 -0600
Message-ID: <53FF3D16.6000509@kernel.dk>
References: <1409213698-10136-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409213698-10136-1-git-send-email-makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 08/28/2014 02:14 AM, Toshiaki Makita wrote:
> Explain that weight has to be updated on activation.
> This complements previous fix e15693ef18e1 ("cfq-iosched: Fix wrong
> children_weight calculation").

Applied, thanks.

-- 
Jens Axboe
