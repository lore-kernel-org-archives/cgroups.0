From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Tue, 30 Jul 2019 00:03:28 -0700
Message-ID: <80fbaf63ddbe66cbbf3391256402295af1a3336f.camel@perches.com>
References: <20190729151346.9280-1-hslester96@gmail.com>
         <201907292117.DA40CA7D@keescook>
         <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chuhong Yuan <hslester96@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>

On Tue, 2019-07-30 at 14:39 +0800, Chuhong Yuan wrote:
> Kees Cook <keescook@chromium.org> 于2019年7月30日周二 下午12:26写道：
> > On Mon, Jul 29, 2019 at 11:13:46PM +0800, Chuhong Yuan wrote:
> > > strncmp(str, const, len) is error-prone.
> > > We had better use newly introduced
> > > str_has_prefix() instead of it.
> > 
> > Wait, stop. :) After Laura called my attention to your conversion series,
> > mpe pointed out that str_has_prefix() is almost redundant to strstarts()
> > (from 2009), and the latter has many more users. Let's fix strstarts()
> > match str_has_prefix()'s return behavior (all the existing callers are
> > doing boolean tests, so the change in return value won't matter), and
> > then we can continue with this replacement. (And add some documentation
> > to Documenation/process/deprecated.rst along with a checkpatch.pl test
> > maybe too?)
> > 
> 
> Thanks for your advice!
> Does that mean replacing strstarts()'s implementation with
> str_has_prefix()'s and then use strstarts() to substitute
> strncmp?
> 
> I am not very clear about how to add the test into checkpatch.pl.
> Should I write a check for this pattern or directly add strncmp into
> deprecated_apis?

After Nitin's patch gets applied: (which btw wasn't cc'd to lkml)

(sorry about the bad link, something about it hits some
 spam filter)

open wall . com/lists/kernel-hardening/2019/07/28/1

Add it to deprecated_string_apis

And we've had this sort of discussion before:

https://lore.kernel.org/patchwork/patch/1026598/

I believe I'm still in favor of global conversion of
strstarts to str_has_prefix.


