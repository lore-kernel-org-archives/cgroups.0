From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/14] Present useful limits to user (v2)
Date: Fri, 15 Jul 2016 13:54:44 -0700
Message-ID: <201607152054.u6FKslD1005327__46839.8933801383$1468618885$gmane$org@mail.zytor.com>
References: <1468578983-28229-1-git-send-email-toiwoton@gmail.com> <20160715124330.GR30154@twins.programming.kicks-ass.net> <28b4b919-4f50-d9f6-c5e1-d1e92ea1ba1c@gmail.com> <20160715135956.GA3115@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160715135956.GA3115-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Graf <agraf-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Radim Kr??m???? <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex

<lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>,Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>,Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>,Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>,Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>,Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,"Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
 ,Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>,Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,!
 "Eric W.
Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>,Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>,Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>,Wang Xiaoqiang <wangxq10-Uu6Fka/qEtMnDS1+zs4M5A@public.gmane.org>,Helge Deller <deller-Mmb7MZpHnFY@public.gmane.org>,Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>,Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>,Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,Alexander Kuleshov <kuleshovmail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,"open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:IA64 (Itanium) PLATFORM" <linux-ia6
 4@vger.kernel.org>,"open list:KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC" <kvm-ppc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:LINUX FOR POWERPC!
  (32-BIT
AND 64-BIT)" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>,"open list:INFINIBAND SUBSYSTEM" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:BPF (Safe dynamic programs and tools)" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,"open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Message-ID: <D79806FE-E6B9-481B-8AA2-A1800419D9B5-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>

On July 15, 2016 6:59:56 AM PDT, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>On Fri, Jul 15, 2016 at 01:52:48PM +0000, Topi Miettinen wrote:
>> On 07/15/16 12:43, Peter Zijlstra wrote:
>> > On Fri, Jul 15, 2016 at 01:35:47PM +0300, Topi Miettinen wrote:
>> >> Hello,
>> >>
>> >> There are many basic ways to control processes, including
>capabilities,
>> >> cgroups and resource limits. However, there are far fewer ways to
>find out
>> >> useful values for the limits, except blind trial and error.
>> >>
>> >> This patch series attempts to fix that by giving at least a nice
>starting
>> >> point from the highwater mark values of the resources in question.
>> >> I looked where each limit is checked and added a call to update
>the mark
>> >> nearby.
>> > 
>> > And how is that useful? Setting things to the high watermark is
>> > basically the same as not setting the limit at all.
>> 
>> What else would you use, too small limits?
>
>That question doesn't make sense.
>
>What's the point of setting a limit if it ends up being the same as
>no-limit (aka unlimited).
>
>If you cannot explain; and you have not so far; what use these values
>are, why would we look at the patches.

One reason is to catch a malfunctioning process rather than dragging the whole system down with it.  It could also be useful for development.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
