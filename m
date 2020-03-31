From: Weiping Zhang <zwp10758@gmail.com>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and nvme
Date: Wed, 1 Apr 2020 00:52:10 +0800
Message-ID: <CAA70yB7V03mDSi8o8PEv0+8QzqZiA-8SJuGkyOXk5VRF-KHiQQ@mail.gmail.com>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com> <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
 <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com>
 <20200331143635.GS162390@mtj.duckdns.org> <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com>
 <20200331155139.GT162390@mtj.duckdns.org> <20200331155257.GA22994@lst.de>
 <CAA70yB6PYH-W8-RRd7nxXOvpg6n+_-h_BLm6JA3EbLmsYG-ZSw@mail.gmail.com> <20200331163337.GA25020@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5QdQJELOcEARpklGhcfRyc4XK3qOpUmQExpfCli9uaw=;
        b=lhnP63q6FHbTkDmsaVAbHbx5O9jgQdz8ILBnXyAQW8EWhoNE3rWAeH2Tb6658qcJt0
         gaoUFgwQSJmbOXCMLvEAAMnRhmfWK9ilMM8HKDi1bTQk5CXhrwBrTThiCXjarfCCTWDm
         Qaxn/T9wtn7ZsVlUGL2cNfzCwSn+jpk0ZPVRp/ByZURLckSKcJHBGXwwdnggw6SH14jT
         y7Y4vjRdNY2paebFxyxhZ2pJi2OFcU11vFO64Pkk0NOs3AXjHhWW9jHCF6zOIrgqRVxj
         ssLVSIETx1ZiWhcUcYkMiJnc94BHHIjGTHVHBzW/WvKgNhKGXZdLU76w1+1kakDhqkVh
         WR3g==
In-Reply-To: <20200331163337.GA25020@lst.de>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im <minwoo.im.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ming Lei <ming.lei@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

Christoph Hellwig <hch@lst.de> =E4=BA=8E2020=E5=B9=B44=E6=9C=881=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8812:33=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Apr 01, 2020 at 12:31:17AM +0800, Weiping Zhang wrote:
> > Would you like to share more detail about why NVMe WRR is broken?
>
> Because it only weights command fetching.  It says absolutely nothing
> about command execution.

I know that different ssd vendor may have different implementation,
even some device can work well, seems you have no plan support it.
I drop this patchset.

@Tejun Heo  @Keith Busch
Thanks all of you
