From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/14] block: lift setting the readahead size
 into the block layer
Date: Tue, 15 Sep 2020 09:05:22 +0200
Message-ID: <20200915070522.GA19974@lst.de>
References: <20200726150333.305527-1-hch@lst.de>
	<20200726150333.305527-7-hch@lst.de>
	<20200826220737.GA25613@redhat.com> <20200902151144.GA1738@lst.de>
	<20200902162007.GB5513@redhat.com> <20200910092813.GA27229@lst.de>
	<20200910171541.GB21919@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200910171541.GB21919@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, drbd-dev@tron.linbit.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Sep 10, 2020 at 01:15:41PM -0400, Mike Snitzer wrote:
> > I'll move it to blk_register_queue, which should work just fine.
> 
> That'll work for initial DM table load as part of DM device creation
> (dm_setup_md_queue).  But it won't account for DM table reloads that
> might change underlying devices on a live DM device (done using
> __bind).
> 
> Both dm_setup_md_queue() and __bind() call dm_table_set_restrictions()
> to set/update queue_limits.  It feels like __bind() will need to call a
> new block helper to set/update parts of queue_limits (e.g. ra_pages and
> io_pages).
> 
> Any chance you're open to factoring out that block function as an
> exported symbol for use by blk_register_queue() and code like DM's
> __bind()?

I agree with the problem statement.  OTOH adding an exported helper
for two trivial assignments seems a little silly..

For now I'll just keep the open coded ->io_pages assignment in
dm.  Note that dm doesn't currently update the ->ra_pages value
based on the underlying devices, so an incremental patch to do that
might be useful as well.
