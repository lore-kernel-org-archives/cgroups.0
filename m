From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Fri, 23 May 2014 13:39:57 -0400
Message-ID: <20140523173957.GA31780@htj.dyndns.org>
References: <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
 <20140423192108.GF22755@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=U08RN1NoW6DOHphMg0shbSrrGc60dARUEkX9lgwNIy4=;
        b=bWL7knzPG0f51xUAds2wV0Dn2WixeP6TPZLVU6ZsNCcHJ1wnXPlwHv3e9dLem9lx3a
         lulmZ2DrC9AMdo+fLDlJfHOSDFw0vEbVNIQ/NsYLiaFybemojgrCz8dhi7V4Cyfe80Bt
         KtSR0getEk6HpgyGo14rt0VhkJZXHH1py6YjD2sy2Qgpkee4o5kdxg6WIjqQLNMC0dsH
         l33uyN0IKXwJPrODKTzwaql5vYG2mTveuISONrWQAkBUJiT54M0RXRMgqc7TLQ3WZxfo
         j4ygb2icGA7rG65XfCT4NtGlQEze7c/v/dsIzbZqoqDAuKsXM00qIdTuaXvGk09NGW21
         A9wQ==
Content-Disposition: inline
In-Reply-To: <20140423192108.GF22755@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello, Vivek.

On Wed, Apr 23, 2014 at 03:21:09PM -0400, Vivek Goyal wrote:
> What about sync/async differentiation? Throttling layer seems to flag a request sync
> only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
> request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.

Working on this again, AFAICS, both treat REQ_SYNC the same way as far
as stats are concerned.  If SYNC is set, it's sync; otherwise, it's
accounted as async whether read or write.

Thanks.

-- 
tejun
