From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 07:29:18 -0700
Message-ID: <20190315142918.GA31099@kroah.com>
References: <20190315121813.GY2217@ZenIV.linux.org.uk>
 <20190315074307.GA31430@light.dominikbrodowski.net>
 <3476.1552650285@warthog.procyon.org.uk>
 <20190315115002.GA9055@light.dominikbrodowski.net>
 <11428.1552659870@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552660159;
        bh=KrTZpj4yLdlYHdOsF/SA1H7Z9SlODj7ASCuz1gICevE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x2tYQsTjQ5rLUvKum1mSvmduvLM0OY2byPj+pXkh1yTI6fiwYFYpZFerWjIwgckzD
         8J5XRyRCkMIUBXP0h+sn0X04cx5oeYLaxmRWXJZ5xVy9V4vkWYNbrhM5I4d0JAw5TN
         RrRSbGWo3A7NNWb8ZV4yXKn5Gu4iBVcqvtAsjXR0=
Content-Disposition: inline
In-Reply-To: <11428.1552659870@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dominik Brodowski <linux@dominikbrodowski.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

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

Ask the networking people that question, I have no idea :)
