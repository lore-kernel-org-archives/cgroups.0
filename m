From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Thu, 18 Feb 2016 07:57:24 -0500
Message-ID: <20160218125724.GD6479@mtj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <56C59918.70505@kyup.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oA8rUKKGgSWcqkrAd1hAoNMfTi8hycDRRtgdTpdivjo=;
        b=G8OFDLghfNpYcPX31B0AkQ4hpl095MuzNmPVGsH2y+3HbUGahdkWHRl/VDPJI+46qi
         Lb7tbffagnDAfnMONyi+9BMCa5vTzUTMz/bKvx1Tlx1dtWnRzqUdQMZHviEgc26pEzgz
         /0QSk+XNHeCyw34y3dl3n5z05d955WlC2I0SvwcFk/fnNjp83i9Cj95xJlfxEBIi3np3
         LmvUDROTefAL8h1z9Kkol2YuSDIPIS3pou/A3rE8q+Am4Z+HZXqSjSfoMSWfV/MCTT6M
         zo0ymOB/qufpkCsSsPDB5SPvf7PmkSe7he0pZDcwQ5kQv7gcYW2rBtkHoG+T1DYHKtpz
         JPrQ==
Content-Disposition: inline
In-Reply-To: <56C59918.70505@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel@kyup.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tahsin Erdogan <tahsin@google.com>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

On Thu, Feb 18, 2016 at 12:12:40PM +0200, Nikolay Borisov wrote:
> 
> 
> On 02/16/2016 08:24 PM, Tejun Heo wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-and-tested-by: Tahsin Erdogan <tahsin@google.com>
> > Link: http://lkml.kernel.org/g/CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com
> > Fixes: d10c80955265 ("writeback: implement foreign cgroup inode bdi_writeback switching")
> > Cc: stable@vger.kernel.org #v4.5+
> 
> Why is this tagged for 4.5+ since the commit in question was merged in 4.2?

Up until 4.5, the whole cgroup v2 interface is hidden behind a devel
flag and cgroup writeback can only be used through cgroup v2.

Thanks.

-- 
tejun
