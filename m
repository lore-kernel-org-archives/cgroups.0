From: David Howells <dhowells@redhat.com>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 14:24:30 +0000
Message-ID: <11428.1552659870@warthog.procyon.org.uk>
References: <20190315121813.GY2217@ZenIV.linux.org.uk> <20190315074307.GA31430@light.dominikbrodowski.net> <3476.1552650285@warthog.procyon.org.uk> <20190315115002.GA9055@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315121813.GY2217@ZenIV.linux.org.uk>
Content-ID: <11427.1552659870.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: dhowells@redhat.com, Dominik Brodowski <linux@dominikbrodowski.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> wrote:

> -	if (fc->user_ns)
> -		put_user_ns(fc->user_ns);
> -	fc->user_ns = get_user_ns(netns->user_ns);
> +	if (netns) {
> +		if (fc->user_ns)
> +			put_user_ns(fc->user_ns);
> +		fc->user_ns = get_user_ns(netns->user_ns);
> +	}

This begs the question why is sysfs using the current network namespace's idea
of the user namespace?  Why not just use the one directly from current->cred?

David
