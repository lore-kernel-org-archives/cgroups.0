From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] PM/hibernate: remove the bogus call to get_gendisk
 in software_resume
Date: Sat, 26 Sep 2020 16:05:26 +0200
Message-ID: <20200926140526.GA10379@lst.de>
References: <20200925161447.1486883-1-hch@lst.de> <20200925161447.1486883-3-hch@lst.de> <20200925183828.GC7253@duo.ucw.cz>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200925183828.GC7253@duo.ucw.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Minho Ban <mhban@samsung.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org

On Fri, Sep 25, 2020 at 08:38:28PM +0200, Pavel Machek wrote:
> > -	 * name_to_dev_t is ineffective to verify parition if resume_file is in
> > -	 * integer format. (e.g. major:minor)
> > -	 */
> > -	if (isdigit(resume_file[0]) && resume_wait) {
> > -		int partno;
> > -		while (!get_gendisk(swsusp_resume_device, &partno))
> > -			msleep(10);
> > -	}
> 
> I believe point of this code was to wait for resume device to appear
> -- see the resume_wait condition. It should not be simply removed.

But get_gendisk has absolutely no relation to a device appearing.  So
whatever this code tried to do doesn't make any sense.
