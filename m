From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/15] blk-cgroup: delay blk-cgroup initialization until
 add_disk
Date: Fri, 27 Jan 2023 12:59:20 -1000
Message-ID: <Y9RXSHQtpLKFLDOq@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGAfOWe0SVdQsDd5eQVWsjHBkUXpqcdLORzkGX51TD4=;
        b=UxC+CFvuSnuV2UzyNwU2S/v/4cv76y60avmTZr83q6O2y6KXdHH1ohB+6X2mgxOmG3
         IBkV3bxAkLptT7RCK0sRjfXIFLSghj+b5KOXiOhL7J4KC8zNPwGEvdCzDjWpol22D8aL
         dCOXAU+zQUaE4tu1+fUDq4clpiz2WDb6RZiR8SNRqFjJQBlBvffO/RwqZ8N8MGZW923w
         jQjrVPQjlwA01Jfn+PAaqtlJpvZxBgk3UePk0EO2PcrMfAbznBUemtT/PcQBn4/f9F27
         LOaMLDu/2r9C4Wfsi44ILdVgD18JITmWMTF09g4NDOh/v14tWhopqFJ2kD/wIVXkS+aj
         T2sA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-4-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Tue, Jan 24, 2023 at 07:57:03AM +0100, Christoph Hellwig wrote:
> There is no need to initialize the group code before the disk is marked
                                     ^
				     cgroup

-- 
tejun
