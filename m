From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Sun, 28 Feb 2016 16:53:00 -0500
Message-ID: <20160228215300.GU3965@htj.duckdns.org>
References: <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
 <20160219201805.GZ17997@ZenIV.linux.org.uk>
 <20160219205147.GN13177@mtj.duckdns.org>
 <20160219215811.GA17997@ZenIV.linux.org.uk>
 <20160219221512.GO13177@mtj.duckdns.org>
 <20160219222609.GC17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XoKirL8XH/PJcgoStrFpVSA1S4edhneMOFZCSSZOUjQ=;
        b=kH2SVntE4+ATQcLlweYpJPUfAz6a1xeFYcb/xwhwo2CftrLcjmL+VQ8YRUaywYCjdi
         OopubI4qlFwA3L4mllWzeJwLLKErZvKNq+MIAJGwP6QnG0tvfYwvQAqil1rnrZf5iDJf
         63z8ucIXIELnB5QDVXYY91f97my7p02TChR+8XoLABypFlV6RpI/nnaoissTApU0vhOT
         E/clxMfn6pFWlIxNIJChMWX8l6oOSyYvMo//cTnKjsqLnxlEbpVAnDsy8s87kHdpFNsR
         pvtl+2VB+Vz8XoWvvh8gsx3gIfY/jWJeBlLrY7kOtyn2vU33JemKrmQ0CT19fi9q7YD0
         /7Dg==
Content-Disposition: inline
In-Reply-To: <20160219222609.GC17997-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

Hello, Al.

On Fri, Feb 19, 2016 at 10:26:09PM +0000, Al Viro wrote:
> Is that code OK with e.g. running in parallel with remounting filesystem r/o?

AFAICS, yeah.  It doesn't care about the sb or filesystem at all.  All
it touches is generic inodes and their pages.

Thanks.

-- 
tejun
