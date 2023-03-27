From: David Sterba <dsterba@suse.cz>
Subject: Re: move bio cgroup punting into btrfs
Date: Tue, 28 Mar 2023 01:18:37 +0200
Message-ID: <20230327231837.GK10580@twin.jikos.cz>
References: <20230327004954.728797-1-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679959491;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WdlRcu20z+c7BKlEbocvqiEmoAKTJAqHgdWdlNpOixc=;
        b=zqEYwHVYk/1fekJ/HfRUW6geAiD0HQfgg52m7TfK+G+8OrzgnjABDvWweuIvPB3HIwq5sY
        cGO343iBWZAsAFJMItu8X286rPBFSoMJcSW/BfYxJi7AZJTGtoKE3B19g2Mmz6hjxaVoMo
        IZNCfEwjbZWTLPIy9HPuRi7zufKKpoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679959491;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WdlRcu20z+c7BKlEbocvqiEmoAKTJAqHgdWdlNpOixc=;
        b=K4g5C3QIXiicnrji11RJBHdEEg9C0358ty8j0k5lOA3D2CSdbOmpn+TgIo78Uwb6+4+1xr
        DQ9aFhIMvev9AgBw==
Content-Disposition: inline
In-Reply-To: <20230327004954.728797-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Mar 27, 2023 at 09:49:46AM +0900, Christoph Hellwig wrote:
> Hi all,
> 
> the current code to offload bio submission into a cgroup-specific helper
> thread when sent from the btrfs internal helper threads is a bit ugly.
> 
> This series moves it into btrfs with minimal interference in the core
> code.

I can't speak for the cgroup side, but as btrfs is the only user of the
REQ_CGROUP_PUNT flag pushing it down to the IO submission path makes
sense. Code looks ok, it's a direct conversion.

When the mm/block changes get an Ack I can put it to btrfs for-next.
