From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 14:51:55 +0000
Message-ID: <20190315145155.GZ2217@ZenIV.linux.org.uk>
References: <20190315121813.GY2217@ZenIV.linux.org.uk>
 <20190315074307.GA31430@light.dominikbrodowski.net>
 <3476.1552650285@warthog.procyon.org.uk>
 <20190315115002.GA9055@light.dominikbrodowski.net>
 <11428.1552659870@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11428.1552659870@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

On Fri, Mar 15, 2019 at 02:24:30PM +0000, David Howells wrote:
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > -	if (fc->user_ns)
> > -		put_user_ns(fc->user_ns);
> > -	fc->user_ns = get_user_ns(netns->user_ns);
> > +	if (netns) {
> > +		if (fc->user_ns)
> > +			put_user_ns(fc->user_ns);
> > +		fc->user_ns = get_user_ns(netns->user_ns);
> > +	}
> 
> This begs the question why is sysfs using the current network namespace's idea
> of the user namespace?  Why not just use the one directly from current->cred?

Because it gives access to that netns guts, presumably.  In a saner world sysfs
wouldn't _have_ netns-dependent bits; a separate per-netns filesystem would
contain those, and be mounted separately.  And yes, we do have way too many
kinds of namespaces, along with filesystems that try to mix unrelated bits and
lead to something that looks like Cthulhu's arse after an unfortunate
accident with capsaicin suppository...
