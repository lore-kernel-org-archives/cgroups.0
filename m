From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/8] cgroup: implement cgroup_get_from_path() and expose
 cgroup_put()
Date: Tue, 22 Dec 2015 13:13:11 -0500
Message-ID: <20151222181311.GA5003@mtj.duckdns.org>
References: <1449527935-27056-1-git-send-email-tj@kernel.org>
 <1449527935-27056-4-git-send-email-tj@kernel.org>
 <20151222002240.GA6682@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T34MwskKuY/HHmGorOjF5fap+dzBGdIGUc3WovfWWgQ=;
        b=m8CNzeeubhkQkpk3zmYteCHh0BaT3qFOroCXWWo8RK157E0CZhA1hurRABbMKz/8bR
         D7pzekDp4beliy0PnpQAgO9QYeuWNlL6dLc89keos/501PBMJPHbcqdzJ0CNCLQr6jOr
         wcbI1si67bipWGQoDYaVrobNHPmfYxFD9mdr9Tw9khyyhLrXlhApS/vFlESAlAw6KU3M
         lXHtnRShFxhnpU1gKovAsoiZWVI8w2PN3TzRROj7dBLkaaE81qxFEgD69/a1qRqc3AjF
         n28y7qcoXbtinBxglw8LmVsk12+XBlYaaBj3pvq9YSRPXmsV0ePiH+hQ+oHtEWvRFOpV
         Fliw==
Content-Disposition: inline
In-Reply-To: <20151222002240.GA6682@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: davem@davemloft.net, pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, daniel@iogearbox.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, ninasc@fb.com

Hello, Serge.

On Mon, Dec 21, 2015 at 06:22:41PM -0600, Serge E. Hallyn wrote:
> I'm trying to figure out how to handle this in the cgroup ns patchset.
> Is this going to be purely used internally?  From the user i see in
> this patchset it looks like I should leave it be (and have @path always
> be absolute)  Is that right?

Yeap, I don't think this function needs to worry about namespaces.

Thanks.

-- 
tejun
