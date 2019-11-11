From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] cgroup,writeback: don't switch wbs
 immediately on dead wbs if the memcg is dead
Date: Mon, 11 Nov 2019 08:18:16 -0800
Message-ID: <20191111161816.GA4163745@devbig004.ftw2.facebook.com>
References: <20191108201829.GA3728460@devbig004.ftw2.facebook.com>
 <20191111131544.GJ1396@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YRVGHXt1HB9qr+Ma06FeEs+skE0icWgw+AMbzL9P2lQ=;
        b=bNsLQ0eI0tap3aMy6CVd2+UQlL25GEXlN+KxXYJ+9xq2sptfLDYMoHpbdW4N/Fzd4K
         nmMNkdUtb70AJTqTgzlunbfQA/F6iX8kz9jww9EfQAMbGCczBotScIUAl+iv2VjKiznn
         o0+25IuHKMmMHgaD+3TS7WgptnVPiEYSrscl9mpqxi2rprKu1BcPSsPSs7vAx/7qRhE/
         NXmHf1kMYrlrjqj51fxdGA+SL1HHvyt/XDaYbJQkMG+cpjo234GidLQmBUMfvBZMaXpq
         Ei20K6D03JnVveAQ9G4pS+VHtEYqugUyZN7euKS6VjQmJaT8sMP9ZJI3n1yyoAFYzoRJ
         7+pw==
Content-Disposition: inline
In-Reply-To: <20191111131544.GJ1396@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Dennis Zhou <dennis@kernel.org>, Michal Hocko <mhocko@kernel.org>

Hello, Michal.

On Mon, Nov 11, 2019 at 02:15:44PM +0100, Michal Hocko wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Dennis Zhou <dennis@kernel.org>
> > Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
> 
> Is this a stable material?

c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
no dirty pages") likely addresses larger part of the problem, but yeah
it prolly makes sense to backport both for -stable.

Greg, Sasha, can you pick the following two commits for -stable?

* c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has
  no dirty pages")

* 65de03e25138 ("cgroup,writeback: don't switch wbs immediately on
  dead wbs if the memcg is dead")

Both are fixes for e8a7abf5a5bd ("writeback: disassociate inodes from
dying bdi_writebacks") - v4.2+.

Thanks.

-- 
tejun
