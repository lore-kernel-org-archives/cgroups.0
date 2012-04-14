From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Lsf] [RFC] writeback and cgroup
Date: Sat, 14 Apr 2012 14:15:16 +0200
Message-ID: <1334405716.2528.88.camel@twins>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120404145134.GC12676@redhat.com>
	 <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
	 <CAH2r5mvP56D0y4mk5wKrJcj+=OZ0e0Q5No_L+9a8a=GMcEhRew@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAH2r5mvP56D0y4mk5wKrJcj+=OZ0e0Q5No_L+9a8a=GMcEhRew@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Steve French <smfrench@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, ctalbott@google.com, rni@google.com, andrea@betterlinux.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org, linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, 2012-04-04 at 14:23 -0500, Steve French wrote:
> Current use of bdi is a little hard to understand since
> there are 25+ fields in the structure. =20

Filesystems only need a small fraction of those.

In particular,

  backing_dev_info::name	-- string
  backing_dev_info::ra_pages	-- number of read-ahead-pages
  backing_dev_info::capability	-- see BDI_CAP_*
 =20
One should properly initialize/destroy the thing using:

  bdi_init()/bdi_destroy()


Furthermore, it has hooks into the regular page-writeback stuff:

  test_{set,clear}_page_writeback()/bdi_writeout_inc()
  set_page_dirty()/account_page_dirtied()
 =20
but also allows filesystems to do custom stuff, see FUSE for example.

The only other bit is the pressure valve, aka.
{set,clear}_bdi_congested(). Which really is rather broken and of
dubious value.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
