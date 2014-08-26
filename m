From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cfq-iosched: Fix wrong children_weight calculation
Date: Tue, 26 Aug 2014 11:47:11 -0400
Message-ID: <20140826154711.GF29286@htj.dyndns.org>
References: <1409054196-20945-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <20140826154637.GE29286@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J8sBqjXl3MLogGkBfah9023wplStCGyTMhaiYRA1ft0=;
        b=JsLJW/xXuMMC7rR+DZGN9islhUOxvqhv+OEO/BX6Rc+K42ri6mr22XMoCV5lNYDR/F
         lD/LrV1vsflgjhmsGWPypcWcsMXn1taJ8b9PNzFIy9+JiR9EuprixpKx+CEuXeY/H5/q
         bh1Fbj8NAyDIGVgIGKlGs5vgwcwPW1c1rIptA6H5Lo6MCrZ/Ft/sb6GdsIU8wpCggDDO
         MrryEdc8C9AuuD+z86a8TMkxb9NIspgqQs4Dg+C2JY2Qti3Gmh3Da1d6E9BONiZzB0XN
         RiLko4IZI84N1k4ZR8rie4bakJINnTBqrI1P0+y5J9ony8usTpTAnqt/PvqFMgDENuye
         rQtg==
Content-Disposition: inline
In-Reply-To: <20140826154637.GE29286-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 26, 2014 at 11:46:37AM -0400, Tejun Heo wrote:
...
> Comment in the code explaining that new_weight application has to
> happen only on activation would be nice tho.

Also, please add "Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org".

Thanks.

-- 
tejun
