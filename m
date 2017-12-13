From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] writeback: synchronize sync(2) against cgroup
 writeback membership switches
Date: Wed, 13 Dec 2017 07:39:30 -0800
Message-ID: <20171213153930.GO3919388@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
 <20171212163830.GC3919388@devbig577.frc2.facebook.com>
 <20171213110004.GB23068@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y3U6H016CWdsphrrJpMDzto2PEwaA4x2UDEHw2DynLc=;
        b=V5HKUYJa1RNTsT6D9TTWQMibZrSj8lrcdwHOMgCRmIkmxT+sn+T7RaarW7BlJ0rzB4
         VR3ix39r9gVoFHh+MM9B8v/457Us+YkKX4+d0Qy361VYjI2d2g6hvrQ04PEUKVY6rya1
         wnr2cpy3xqADchRFUHqgAnlksncy/ObHR/TuvoYeptjA5NiXsJIGlu+4kuWBqsB34yrO
         6kYs86DVIZnX6KDWF1at9Tuy26hyeMiaRfMR3BcptmmepF9HW61Cbxh91731jx2DcXN8
         yudaCUeroYmbN6Pjeryt3pzsL2QPoQ01tgYp5FZjD9R4/YepbeRUFw+3v/kImKseHuTJ
         5R9w==
Content-Disposition: inline
In-Reply-To: <20171213110004.GB23068@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, xuejiufei <xuejiufei@gmail.com>, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hello,

On Wed, Dec 13, 2017 at 12:00:04PM +0100, Jan Kara wrote:
> OK, but this effectively prevents writeback from sync_inodes_sb() to ever
> make inode switch wbs. Cannot that be abused in some way like making sure
> writeback of our memcg is "invisible" by forcing it out using sync(2)? It
> just looks a bit dangerous to me...

That's true.  There are a couple mitigating factors tho.

* While it can delay switching during sync(2), it'll all still be
  recorded and the switch will happen soon if needed.

* sync(2) is hugely disruptive with or without this and can easily be
  used to DOS the whole system.  People are working on restricting the
  blast radius of sync(2) to mitigate this problem, which most likely
  make this a non-problem too.

If you can think of a better solution, I'm all ears.

Thanks.

-- 
tejun
