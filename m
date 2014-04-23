From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 15:00:43 -0400
Message-ID: <20140423190043.GB4163@mtj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dx+DSrPLAkj2tjc0XF3g89tXKEpY3g0YpDTqep0a3hE=;
        b=YX7i90aPEa0dGbkEquZF+18R/hRUVoHvcmgKID6m46fjU5gLCMWlt8YWY63t0MtfTW
         2pdzweSYnMZ/TwuQQhHNIl0ZbD2au2bcUWqNiiZntryO7S+6iSh9TZTAAB602pfjkX1O
         nRNKg8Y5WS7+3BOhVgpCkhKJ+KEiq7xzFGhBwtLsjJWV77CukUISTDO6zUFD9SPrYfbC
         CILMxl/9qk+oNPl3eDktipKrEm3jfJpXbL/IXXk6PxXqfl7svgpnVX0SpdkWngQKolaM
         CDjPNg5vHV+esaAvWNmG0juIhCRSl067ny8H0ivdP+lsD1HWrhQZ0p0mzzSKZVUxIi59
         6ZBQ==
Content-Disposition: inline
In-Reply-To: <20140423185835.GD22755@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello,

On Wed, Apr 23, 2014 at 02:58:35PM -0400, Vivek Goyal wrote:
> Oh, sorry, I had misunderstood your question.
> 
> - Number of IOs serviced will be different at throttling layer and
>   CFQ layer as throttling accounts IO in terms of bios and CFQ
>   accounts in terms of number of requests.

But shouldn't it be possible to determine that from merged count?  Or
we can just expose both bio and request counts at block core layer.
The point is that there's nothing controller specific about these
stats.

> - CFQ might not be operational on a device while throttling might be
>   on and one needs bytes stats.

Yeah, so expose both from blkcg core as blkio.* stats.

> - In a custom kernel throttling might not be on and CFQ is on and
>   one needs the stats.

Ditto.

Thanks.

-- 
tejun
