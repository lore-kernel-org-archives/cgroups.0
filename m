From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: INFO: rcu detected stall in bitmap_parselist
Date: Thu, 5 Apr 2018 00:58:46 +0900
Message-ID: <201804050058.EIB64593.LtSFQHFJOMOVFO@I-love.SAKURA.ne.jp>
References: <000000000000edc3690568cc95eb@google.com>
        <f1a0af0d-44c5-e938-b48f-0bace885f0a2@I-love.SAKURA.ne.jp>
        <20180404154136.p7aeye7657q466sq@yury-thinkpad>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180404154136.p7aeye7657q466sq@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ynorov@caviumnetworks.com
Cc: syzbot+6887cbb011c8054e8a3d@syzkaller.appspotmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, syzkaller-bugs@googlegroups.com, noamca@mellanox.com, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, akpm@linux-foundation.org

Yury Norov wrote:
> Hi Tetsuo,
> 
> Thanks for the patch.
> 
> On Wed, Apr 04, 2018 at 09:21:43PM +0900, Tetsuo Handa wrote:
> > Yury, are you OK with this patch?
> > 
> > 
> > >From 7f21827cdfe9780b4949b22bcd19efa721b463d2 Mon Sep 17 00:00:00 2001
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date: Wed, 4 Apr 2018 21:12:10 +0900
> > Subject: [PATCH] lib/bitmap: Rewrite __bitmap_parselist().
> > 
> > syzbot is catching stalls at __bitmap_parselist() [1]. The trigger is
> > 
> >   unsigned long v = 0;
> >   bitmap_parselist("7:,", &v, BITS_PER_LONG);
> 
> Could you add this case to the test_bitmap_parselist()?
> 
> > which results in hitting infinite loop at
> > 
> >   while (a <= b) {
> >     off = min(b - a + 1, used_size);
> >     bitmap_set(maskp, a, off);
> >     a += group_size;
> >   }
> > 
> > due to used_size == group_size == 0.
> > 
> > Current code is difficult to read due to too many flag variables.
> > Let's rewrite it.
> 
> I also don't like current implementation of bitmap_parselist(), but
> discussion on new code  may take some time. Can you submit minimal
> fix in separated patch to let people discuss your new implementation
> without rush?

OK. Then you can write the patch. You know current code better than I.

> > @@ -485,6 +485,58 @@ int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
> >  }
> >  EXPORT_SYMBOL(bitmap_print_to_pagebuf);
> >  
> > +static bool get_uint(const char **buf, unsigned int *res)
> > +{
> > +	const char *p = *buf;
> > +
> > +	if (!isdigit(*p))
> > +		return false;
> > +	*res = simple_strtoul(p, (char **) buf, 10);
> 
> In comment to simple_strtoul(): "This function is obsolete. Please
> use kstrtoul instead."

I intentionally choose simple_strtoul() because next delimiter (e.g. '-')
starts at returned address. kstrtoul() fails if next letter starts.

> 
> > +	return p < *buf;

I think I should limit to "0 <= *res <= INT_MAX" range in order to avoid
overflow at start += group_size.

> > +}
> > +
> > +static int __bitmap_parse_one_chunk(const char *buf, unsigned long *maskp,
> > +				    const unsigned int nmaskbits)
> > +{
> > +	unsigned int start;
> > +	unsigned int end;
> > +	unsigned int group_size;
> > +	unsigned int used_size;
> > +
> > +	while (*buf && isspace(*buf))
> > +		buf++;
> > +	if (!get_uint(&buf, &start))
> > +		return -EINVAL;
> > +	if (*buf == '-') {
> > +		buf++;
> > +		if (!get_uint(&buf, &end) || start > end)
> > +			return -EINVAL;
> > +		if (*buf == ':') {
> > +			buf++;
> > +			if (!get_uint(&buf, &used_size) || *buf++ != '/' ||
> > +			    !get_uint(&buf, &group_size) ||
> > +			    used_size > group_size)
> > +				return -EINVAL;
> 
> So this is still not safe against "1-10:0/0", or I miss something?
> (This is another testcase we should add to test_bitmap.c)

Indeed. We need to make more testcases.

> > +	while (buflen && !err) {
> > +		char *cp;
> > +		char tmpbuf[256];
> > +		unsigned int size = min(buflen,
> > +					(unsigned int) sizeof(tmpbuf) - 1);
> > +
> > +		if (!is_user)
> > +			memcpy(tmpbuf, buf, size);
> > +		else if (copy_from_user(tmpbuf, (const char __user __force *)
> > +					buf, size))
> > +			return -EFAULT;
> 
> This is not safe against this:
> "[250 whitespaces] 567-890:123/456"

Do we need to accept such insane entry?

> 
> And it will be Schlemiel the painter's-styled algorithm for input like:
> "1,2,3,4, ... ,98,99,100". 
> 
> I think we need something like __bitmap_parse_get_chunk() to copy
> coma-separated substrings.
