From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 00/12 (RESEND)] syfs: generic deadlock fix with module
 removal
Date: Mon, 20 Sep 2021 07:55:13 -1000
Message-ID: <YUjLAbnEB5qPfnL8@slm.duckdns.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vR0eyDgW0+ZEcHoejwvFez2+LwYKhi8aV0OBAhaelJo=;
        b=p604AQfCitOKbr2cWdPPPs2nIliLZL00TGv3Mox5xld5PWEq869Y8KyemmmF7xDKy+
         eznw9TiloP+yS7DvUdNW3EUPHieVBVpmlNyfHCirogTorYJwxpfJpot5/Ncknl0xQAaH
         keNk/Kkw3utp2XrCGofJr7QxW+Z2eQxrPAlQNS/Hg3Xssdo9nLf1uk5t6rqnexz3sqqQ
         CoXnFX4FmD5398RDC+ganCKBppgTv5Kx+xDyR87QID3hEpYWy592gHpA/ulKd3vB4TeC
         nnXt3QpQy2wo59YDhIX9TDeNkTdxMt2xRg+S4TUzt9xzf7WJ6IT8GWvz0JS7bvFq2+KJ
         Wf+A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210918050430.3671227-1-mcgrof@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org, rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@i-love.sakura.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@aculab.com, bvanassche@acm.org, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmp

On Fri, Sep 17, 2021 at 10:04:18PM -0700, Luis Chamberlain wrote:
> In this v7 I've decided it is best to merge all the effort together into
> one patch set because communication was being lost when I split the
> patches up. This was not helping in any way to either fix the zram
> issues or come to consensus on a generic solution. The patches are also
> merged now because they are all related now.

Building up all the testing framewoork is really great. I have no opinions
about the license related stuff but all other changes generally look good to
me.

Thanks.

-- 
tejun
