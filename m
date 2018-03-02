From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Fri, 2 Mar 2018 10:23:21 -0800
Message-ID: <20180302182321.GE31400@bombadil.infradead.org>
References: <cover.1519930146.git.rgb@redhat.com>
 <2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
 <20180302014101.jtfd2eeyxmvxcjpf@madcap2.tricolour.ca>
 <CAHC9VhQi2QC8_e1fgYr=bfTACdtpgXZubc6S18r+1+9qf6TJ8w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EYymhwisN2oH/TJ7dQ60UNTymZYTgjqrwLduQsGn+X0=; b=EXsyjtqi6i9PF28h47HyMO6DT
        zTNuB90GDYsAfvQt8YFTwfOG7HhdMAEoKD0W3IPbibiCXnLHPzYqHrZiGorvAad5NJPYdlUCu8EQ7
        zoFB/l4jFZkjaw7wVt5BNuDXUKuKbNhd+pBPw0i94nswlTZmTB//kT1JTquZPvsRZ+i3nAil4JM8l
        MHkhmWRi7jbnDQpyKKYvUdmWpCSoVIsa0eI+O0btPBq8a43XVy+N7hNogCFyEqaK7pOU4axjmymVQ
        lSkuXhaQ4vBZ4gi9NcZEvQorvFzLzBzT3i3Zc73gBlKm9kNVWvWn3qO6jufbNJ+4q7b2amawYSoeQ
    
Content-Disposition: inline
In-Reply-To: <CAHC9VhQi2QC8_e1fgYr=bfTACdtpgXZubc6S18r+1+9qf6TJ8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, mszeredi@redhat.com, ebiederm@xmission.com, simo@redhat.com, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, luto@kernel.org, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, serge@hallyn.com

On Fri, Mar 02, 2018 at 10:48:42AM -0500, Paul Moore wrote:
> On Thu, Mar 1, 2018 at 8:41 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2018-03-01 14:41, Richard Guy Briggs wrote:
> FYI, I think you may have a problem with something in your outgoing
> mail path; I didn't receive the original patchset you are referencing
> and it doesn't appear in the mail archive either.

I have those patches.  Which mail archive is missing them?
