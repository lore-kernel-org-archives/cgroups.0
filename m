From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Mon, 13 Apr 2020 10:02:06 -0400
Message-ID: <20200413140206.GC60335@mtj.duckdns.org>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <20200409014406.GA370295@localhost.localdomain>
 <20200409021119.GJ162390@mtj.duckdns.org>
 <20200409023857.GB370295@localhost.localdomain>
 <c2b362f5-36f6-116d-ddb5-2445d13d2bac@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITKk+IbM/Pu4iwCMAU82Dk9TCoQ6Vio94t7SmWjtKJY=;
        b=oohXv3GgKxF3JQKxq9eUkBNfeVoWdmwO7PciLXRyq4R+kxI5Zv/hFU86wvO2vaGEoY
         +ba/L/ysawNwxImhrJb5CEqTgej8lP9ibrtHhTLvVC+6zXe6LIt/4yoNNwDY8OpSRav8
         U0xVcD2Z/xP1RsSjMZl/LoerF2n1ace3iy+jfUvTqyF5EJuLsQaWLbU/nxo5SlHmp/oG
         XCSvoOd1kAzphvtwpgGZ4b/DIE6agvYmKEBDWiRYhrziszA+RKx/ypDrs/+0Lzx7EITX
         v+EYF1mOEHuHuUhWdGqzauOd9kR0Qvy6IIDglBUr0hAGP4sXyjbVkmdC1YH3N5FYuTtW
         8i8w==
Content-Disposition: inline
In-Reply-To: <c2b362f5-36f6-116d-ddb5-2445d13d2bac@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com

Hello,

On Thu, Apr 09, 2020 at 08:08:59AM +0300, Pavel Begunkov wrote:
> struct request already has such field (see @stats_sectors) because of the same
> root-cause. I'd prefer killing it as well by following Ming's way, but otherwise
> it could be easily adopted.

Oh, I completely missed that field. Lemme just use that one instead. Please
disregard this patch. As for killing partial completions, while I'm not
necessarily against it, it isn't a no brainer either.

Thanks.

-- 
tejun
