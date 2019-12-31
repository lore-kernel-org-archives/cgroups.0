From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 00/10] per lruvec lru_lock for memcg
Date: Tue, 31 Dec 2019 15:05:14 -0800
Message-ID: <20191231150514.61c2b8c8354320f09b09f377@linux-foundation.org>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577833515;
        bh=2JRDEcONOOpeU0TxkjV7WoTCxeEf9fZaWWxMhwx7i8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MRddLrwYS3egNicCrnLw9LAAmaqqevPs4Ss/3/JtxisDiy01nCs2CsIvKPioA/l6N
         pHwlAnwDnZkgDa37ZpauBUhVd5ELv4fybysP9M7sUxY35hNWTScoYqRGoH8pRWOw9b
         YdpRaUNRvib77Pmt+6vVPW285q1Umj9w2d7O0Vbo=
In-Reply-To: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org

On Wed, 25 Dec 2019 17:04:16 +0800 Alex Shi <alex.shi@linux.alibaba.com> wrote:

> This patchset move lru_lock into lruvec, give a lru_lock for each of
> lruvec, thus bring a lru_lock for each of memcg per node.

I see that there has been plenty of feedback on previous versions, but
no acked/reviewed tags as yet.

I think I'll take a pass for now, see what the audience feedback looks
like ;)

