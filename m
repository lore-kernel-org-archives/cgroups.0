From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
Date: Thu, 17 Apr 2014 12:23:52 -0700
Message-ID: <CALCETrXbATieFBmFb0SzR=pwsAZ7KvAubFi1EcesuFkOKA_=eQ@mail.gmail.com>
References: <CALCETrUrj2LtAoXp600BD2ANgE2UUEbTYQrK8hHqDR=qpeFPcg@mail.gmail.com>
 <1397751853.2628.50.camel@willson.li.ssimo.org> <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
 <1397753323.2628.60.camel@willson.li.ssimo.org> <CALCETrXj6kD3E+vsaWmkrSbaQYTu=c-Hsw640jh4O+FbojYk2g@mail.gmail.com>
 <20140417171256.GB25334@redhat.com> <CALCETrVq4HRpfWOAbZAQbyjuraQd=OxnW=WjSoe5JgBzRStiKg@mail.gmail.com>
 <1397756025.2628.64.camel@willson.li.ssimo.org> <CALCETrVBJFgKwRKBE2jAG6kiGgkJ+MyQiw2nyz5yj0h68kCk9A@mail.gmail.com>
 <1397759013.2628.86.camel@willson.li.ssimo.org> <20140417185023.GA32527@redhat.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20140417185023.GA32527@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simo Sorce <ssorce@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>, David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com, Network Development <netdev@vger.kernel.org>

On Thu, Apr 17, 2014 at 11:50 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 17, 2014 at 02:23:33PM -0400, Simo Sorce wrote:
>> Perhaps this could be done with a sendmsg() header flag or simplified
>> ancillary data even, rather than forcing the sender process to retrieve
>> and construct the whole information which is already available in
>> kernel.
>
> So what would be the protocol here? When should somebody send an
> SCM_CGROUP message using sendmsg()?
>

Presumably whenever it knows talking to someone who cares about the
cgroup.  Since I don't understand why you would want to know someone's
cgroup when speaking a protocol that didn't previously require cgroup
infomation, I don't really have a good answer for you.

--Andy
