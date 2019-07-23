From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm/backing-dev: show state of all bdi_writeback in
 debugfs
Date: Tue, 23 Jul 2019 15:36:21 -0700
Message-ID: <20190723223621.GF696309@devbig004.ftw2.facebook.com>
References: <156388617236.3608.2194886130557491278.stgit@buzz>
 <20190723130729.522976a1f075d748fc946ff6@linux-foundation.org>
 <CALYGNiMw_9MKxfCxq9QsXi3PbwQMwKmLufQqUnhYdt8C+sR2rA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zNouKbF6UyPadfEdFSK5fRF7G6CWHnxRN1FzAl+dNYs=;
        b=SdQIiqD4fkEQwr9X83RCA6yuwNBY1uChpKnXh3cAh+UZV7T/q90T66/ebWnSWzMdU1
         4ZhW4dn/MufMU2L+7JiJDj0tARsd7/JfDcK7Kqqk3vaKGtlGIJNFTFOKuIVEJ0tJg6HV
         nJBlNrJlbG4z+e88LPyvn8BrL/xxUJQuiugCiM1POSvapwm84nYrkEXh/Mp5F/0QCKHD
         T4d7iSWVbnhNQvkYjTIxXZMgF9DK7sKqcgjD1ReNDbfobnDjlowVaYpWEDPDMZN2xhW7
         pis75BozdMnhMsLgEScEd3kHzIXXtW8zbGK+ErLn5nFgdmWdRJBTzk0v8ZxIrsyj4e4i
         052A==
Content-Disposition: inline
In-Reply-To: <CALYGNiMw_9MKxfCxq9QsXi3PbwQMwKmLufQqUnhYdt8C+sR2rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>

On Wed, Jul 24, 2019 at 12:24:41AM +0300, Konstantin Khlebnikov wrote:
> Debugging such dynamic structure with gdb is a pain.

Use drgn.  It's a lot better than hard coding these debug features
into the kernel.

  https://github.com/osandov/drgn

Thanks.

-- 
tejun
